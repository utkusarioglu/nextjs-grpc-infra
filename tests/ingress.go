package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
)

type IngressInstances struct {
	namespace   string
	serviceName string
}

var ingressInstances = []IngressInstances{
	{
		namespace:   "api",
		serviceName: "web-server",
	},
	{
		namespace:   "observability",
		serviceName: "grafana-ingress",
	},
	{
		namespace:   "observability",
		serviceName: "prometheus-server",
	},
	{
		namespace:   "observability",
		serviceName: "kubernetes-dashboard",
	},
	{
		namespace:   "observability",
		serviceName: "jaeger-query",
	},
	{
		namespace:   "vault",
		serviceName: "vault",
	},
}

func IngressTests(t *testing.T) func() {
	return func() {
		for _, props := range ingressInstances {
			fmt.Printf("Getting ingress for %s…", props.serviceName)
			k8s.GetIngress(t, &k8s.KubectlOptions{
				Namespace: props.namespace,
			}, props.serviceName)
		}
	}
}
