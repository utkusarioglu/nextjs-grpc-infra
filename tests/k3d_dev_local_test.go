package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestK3dDevLocal(t *testing.T) {
	t.Parallel()

	SetupCluster(t, "k3d/dev/local")
	kubernetesTests(t)

	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, ".")
		terraform.TgDestroyAll(t, terraformOptions)
	})
}

func kubernetesTests(t *testing.T) {
	test_structure.RunTestStage(t, "ingress", IngressTests(t))
	test_structure.RunTestStage(t, "observability", ObservabilityTests(t))
	test_structure.RunTestStage(t, "endpoint", EndpointTests(t))
}
