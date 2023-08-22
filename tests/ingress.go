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

var servicesIngressInstances = []IngressInstances{
	{
		namespace:   "api",
		serviceName: "web-server",
	},
}

var vaultIngressInstances = []IngressInstances{
	{
		namespace:   "vault",
		serviceName: "vault",
	},
}

var observabilityIngressInstances = []IngressInstances{
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
}

func IngressTests(t *testing.T) func() {
	ingressInstances := []IngressInstances{}
	ingressInstances = append(ingressInstances, servicesIngressInstances...)
	ingressInstances = append(ingressInstances, vaultIngressInstances...)

	if IsObservabilityEnabled() {
		ingressInstances = append(ingressInstances, observabilityIngressInstances...)
	}

	return func() {
		for _, props := range ingressInstances {
			fmt.Printf("Getting ingress for %s…", props.serviceName)
			k8s.GetIngress(t, &k8s.KubectlOptions{
				Namespace: props.namespace,
			}, props.serviceName)
		}
	}
}
