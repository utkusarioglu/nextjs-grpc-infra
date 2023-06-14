# This script file pulls cert-manager certificates created for api and ms
# microservices into the `.certs` folder of the corresponding repos. This is 
# useful for testing services while the cluster is not running.

function Copy-PodFile {
  Param (
    [string]$Namespace,
    [string]$PodPrefix,
    [string]$ContainerName,
    [string]$SourceAbsPath,
    [string]$TargetProjectAbsPath,
    [string]$TargetRepoRelPath,
    [string]$Filename
  )

  $TargetRepoAbsPath = "$TargetProjectAbsPath\$TargetRepoRelPath"
  New-Item -type directory $TargetRepoAbsPath -Force | Out-Null

  $PodName = kubectl -n "$Namespace" get po -o yaml `
    | yq ".items[].metadata.name | select(. == `"$PodPrefix-*`")"

  kubectl `
    -n $Namespace exec -it $PodName -c $ContainerName `
    -- bash -c "cat $SourceAbsPath/$Filename" `
    > "$TargetRepoAbsPath\$Filename"
  
  Write-Host "Copied $Filename from $PodName to $TargetRepoRelPath"
}

$ProjectPath = @(
  'Microsoft.PowerShell.Core\FileSystem::\', 
  'wsl.localhost\u-Boulanger',
  'home\utkusarioglu\dev\projects',
  'nextjs-grpc'
) -join '\'

$Files = @(
  # ms crt for ms
  @{
    'Namespace' = 'ms'
    'PodPrefix' = 'ms'
    'ContainerName' = 'ms'
    'Files' = @(
      @{
        'SourceAbsPath' = '/.certificates/grpc-server/'
        'TargetRepoRelPath' = "ms\.certs\ms"
        'Filename' = 'ca.crt'
      },
      @{
        'SourceAbsPath' = '/.certificates/grpc-server/'
        'TargetRepoRelPath' = "ms\.certs\ms"
        'Filename' = 'tls.crt'
      },
      @{
        'SourceAbsPath' = '/.certificates/grpc-server/'
        'TargetRepoRelPath' = "ms\.certs\ms"
        'Filename' = 'tls.key'
      }
    )
  },
  
  # Api crt for api
  @{
    'Namespace' = 'api'
    'PodPrefix' = 'api'
    'ContainerName' = 'api'
    'Files' = @(
      @{
        'SourceAbsPath' = '/.certs/ms-grpc-client-cert-for-api/'
        'TargetRepoRelPath' = 'api\.certs\api'
        'Filename' = 'ca.crt'
      },
      @{
        'SourceAbsPath' = '/.certs/ms-grpc-client-cert-for-api/'
        'TargetRepoRelPath' = 'api\.certs\api'
        'Filename' = 'tls.crt'
      },
      @{
        'SourceAbsPath' = '/.certs/ms-grpc-client-cert-for-api/'
        'TargetRepoRelPath' = 'api\.certs\api'
        'Filename' = 'tls.key'
      }
    )
  }
)

foreach($Container in $Files) {
  foreach($File in $Container.Files) {
    Copy-PodFile `
      -Namespace $Container.Namespace `
      -PodPrefix $Container.PodPrefix `
      -ContainerName $Container.ContainerName `
      -SourceAbsPath $File.SourceAbsPath `
      -TargetProjectAbsPath $ProjectPath `
      -TargetRepoRelPath $File.TargetRepoRelPath `
      -Filename $File.Filename 
  }
}
