package test

import (
	"fmt"
	"io/ioutil"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/environment"
	"github.com/gruntwork-io/terratest/modules/logger"
)

func retrieveVarFiles(t *testing.T) []string {
	varsFolder := "vars"
	files, err := ioutil.ReadDir(fmt.Sprintf("../%s", varsFolder))
	if err != nil {
		logger.Log(t, err)
	}
	varFiles := []string{}
	for _, file := range files {
		filename := file.Name()
		isDisabled := strings.Contains(filename, ".disabled.")
		isCommon := strings.Contains(filename, ".common.")
		isTfVars := strings.HasSuffix(filename, ".tfvars")
		isTfVarsJson := strings.HasSuffix(filename, ".tfvars.json")
		isExample := strings.HasSuffix(filename, ".example")
		environment := environment.GetFirstNonEmptyEnvVarOrFatal(t, []string {"ENVIRONMENT"})
		isOfCurrentEnvironment := strings.Contains(filename, fmt.Sprintf(".%s.", environment))
		if !isDisabled && (isTfVars || isTfVarsJson) && !isExample && (isOfCurrentEnvironment || isCommon) {
			varFiles = append(varFiles, fmt.Sprintf("%s/%s", varsFolder, filename))
		}
	}
	return varFiles
}

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
