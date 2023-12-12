package test

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

var namespaces = []string{
	"api",
	"ms",
	// "observability",
}

func LogTests(t *testing.T) func() {
	return func() {
		infraAbsPath, err := filepath.Abs("..")
		logsAbsPath := fmt.Sprintf("%s/logs", infraAbsPath)
		if err != nil {
			fmt.Println("Failed to find infra repo path")
			return
		}

		for _, ns := range namespaces {
			pods := k8s.ListPods(t, &k8s.KubectlOptions{Namespace: ns}, v1.ListOptions{})
			for _, pod := range pods {
				for _, container := range pod.Spec.Containers {
					logs := k8s.GetPodLogs(t, &k8s.KubectlOptions{Namespace: ns}, &pod, container.Name)
					containerIdentifier := fmt.Sprintf("%s - %s", pod.Name, container.Name)
					logFilename := fmt.Sprintf("%s.log", containerIdentifier)
					logRelPath := fmt.Sprintf("%s/%s", logsAbsPath, logFilename)

					fmt.Printf("Creating %s", logRelPath)

					logFile, errs := os.Create(logRelPath)
					if errs != nil {
						fmt.Println("Failed to create file:", errs)
						return
					}
					defer logFile.Close()
					_, errs = logFile.WriteString(logs)
					if errs != nil {
						fmt.Println("Failed to write the log to the file", errs)
						return
					}
				}
			}
		}
	}
}
