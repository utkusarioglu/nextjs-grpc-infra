package test

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func createTimestamp() string {
	now := time.Now()
	timestamp := fmt.Sprintf(
		"%d-%02d-%02d-%02d-%02d-%02d",
		now.Year(),
		now.Month(),
		now.Day(),
		now.Hour(),
		now.Minute(),
		now.Second(),
	)
	return timestamp
}

func SetupCluster(t *testing.T, targetSubpath string) string {
	timestamp := createTimestamp()
	infraAbsPath, err := filepath.Abs("..")
	if err != nil {
		fmt.Print(err.Error())
	}
	targetPath := fmt.Sprintf("%s/%s/%s", infraAbsPath, "src/targets", targetSubpath)
	stepName := fmt.Sprintf("setup_%s", strings.Replace(targetSubpath, "/", "_", -1))
	logName := strings.Replace(targetSubpath, "/", "-", -1)
	tfLogPath := fmt.Sprintf(
		"%s/logs/%s-%s.terratest.log",
		infraAbsPath,
		logName,
		timestamp,
	)
	// These should be received from terragrunt platform hcl file
	retryableErrors := map[string]string{
		"Connection Reset":      "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
		"Connection Closed":     "(?s).*ssh_exchange_identification.*Connection closed by remote host.*",
		"Waiting for Condition": "(?s).*timed out waiting for the condition.*",
		"No Such Host":          "(?s).*no such host.*",
	}
	test_structure.RunTestStage(t, stepName, func() {
		terragruntOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			TerraformDir:    targetPath,
			TerraformBinary: "terragrunt",
			EnvVars: map[string]string{
				"TF_LOG_PATH": tfLogPath,
				"TF_LOG":      "INFO",
			},
			Logger:                   logger.Default,
			RetryableTerraformErrors: retryableErrors,
		})
		test_structure.SaveTerraformOptions(t, ".", terragruntOptions)
		terraform.TgApplyAll(t, terragruntOptions)
	})
	return timestamp
}

func IsObservabilityEnabled() bool {
	return os.Getenv("K3D_DEV_LOCAL_DEPLOYMENT_MODE") != "no_observability"
}
