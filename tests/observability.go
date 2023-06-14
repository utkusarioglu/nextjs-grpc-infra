package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
)

func ObservabilityTests(t *testing.T) func() {
	observabilityNamespace := "observability"
	expectedIngresses := []string{
		"jaeger-query",
		"grafana-ingress",
		"prometheus-server",
		"kubernetes-dashboard",
	}

	return func() {
		for _, ingressName := range expectedIngresses {
			k8s.GetIngress(t, &k8s.KubectlOptions{
				Namespace: observabilityNamespace,
			}, ingressName)
		}
	}
}
