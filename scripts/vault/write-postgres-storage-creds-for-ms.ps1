$UserpassUsername = 'notebooks-basic-readonly'
$VaultUrl = 'https://vault.nextjs-grpc.utkusarioglu.com:8200'
$ProjectAbsPathArr = @(
  'Microsoft.PowerShell.Core\FileSystem::\\wsl.localhost\u-Boulanger',
  'home\utkusarioglu\dev\projects',
  'nextjs-grpc'
)
$UserpassPasswordRelPathArr = @(
  'infra',
  'secrets\vault\userpasses',
  "$UserpassUsername.userpass.json"
)
$MsSecretsRelPathArr = @(
  'ms\.secrets\',
  'postgres-storage\inflation'
  'ms.yaml'
) 

function Get-UserpassPassword {
  Param (
    [string[]]$ProjectAbsPathArr,
    [string[]]$UserpassPasswordRelPathArr
  )
  $UserpassPasswordAbsPath = ($ProjectAbsPathArr + $UserpassPasswordRelPathArr) -join '\'
  $UserpassPassword = cat $UserpassPasswordAbsPath | jq -r '.password'
  return $UserpassPassword
}

function Get-ClientToken {
  Param (
    [string]$UserpassUsername,
    [string]$UserpassPassword
  )
  $ClientTokenReqUri = [System.Uri]::New(
    [string]::Join('/', @(
      $VaultUrl, 
      'v1/auth/userpass/login', 
      $UserpassUsername
    ))
  )
  $ClientTokenReqParams = @{
    'Uri' = $ClientTokenReqUri
    'Method' = 'POST'
    'Body' =  @{ 
      'password' = $UserpassPassword 
    }
  }
  $ClientTokenRes = Invoke-WebRequest @ClientTokenReqParams
  $ClientToken = $ClientTokenRes.Content | yq -r '.auth.client_token'
  return $ClientToken
}

class PostgresStorageCredentials {
  [string] $Username
  [string] $Password

  PostgresStorageCredentials([string]$Username, [string]$Password) {
    $this.Username = $Username
    $this.Password = $Password
  }
}

function Get-PostgresStorageCredentials {
  Param (
    [string]$UserpassUsername,
    [string]$ClientToken
  )
  $CredsReqUri = [System.Uri]::New(
      [String]::Join('/', @(
        $VaultUrl, 
        'v1/postgres-storage/inflation/creds', 
        $UserpassUsername
      ))
    )
  $CredsReqParams = @{
    'Method' = 'GET'
    'Uri' = $CredsReqUri
    'Headers' = @{ 
      'X-Vault-Token' = $ClientToken 
    }
  }
  $CredsRes = Invoke-WebRequest @CredsReqParams
  $DbUsername = $CredsRes.Content | jq -r '.data.username'
  $DbPassword = $CredsRes.Content | jq -r '.data.password'

  return [PostgresStorageCredentials]::New($DbUsername, $DbPassword)
}

 function Create-MsPasswordConfig {
    Param (
      [PostgresStorageCredentials] $Credentials
    )
  # This format is dictated by the configuration reqirements of 
  # `ms` repo.
  $CredsYaml = [String]::Join("`r`n", @(
    "postgresStorage:"
    "  credentials:"
    "    inflation:"
    "      username: $($Credentials.Username)"
    "      password: $($Credentials.Password)"
  ))
  return $CredsYaml
}

function Write-MsPasswordYaml {
  Param (
    [string[]] $ProjectAbsPathArr,
    [string[]] $MsSecretsRelPathArr,
    [string] $CredentialsYmlStr
  )
  $MsSecretsAbsPathArr = ($ProjectAbsPathArr + $MsSecretsRelPathArr)
  $MsSecretsAbsPath = $MsSecretsAbsPathArr -join '\'
  $MsSecretsRelPath = $MsSecretsAbsPathArr[-3..-1] -join '\'

  Write-Host "Creating credentials file at `"`$ProjectRoot\$MsSecretsRelPath`"…"
  $CredentialsYmlStr | Out-File $MsSecretsAbsPath
}

$UserpassPassword = Get-UserpassPassword $ProjectAbsPathArr $UserpassPasswordRelPathArr
$ClientToken = Get-ClientToken $UserpassUsername $UserpassPassword
$DbCreds = Get-PostgresStorageCredentials $UserpassUsername $ClientToken
$DbCreds
$YmlString = Create-MsPasswordConfig($DbCreds)
$YmlString
Write-MsPasswordYaml $ProjectAbsPathArr $MsSecretsRelPathArr $YmlString
