package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
)

func K3dClusterTests(t *testing.T) func() {
	return func() {
		nodes := k8s.GetNodes(t, &k8s.KubectlOptions{})
		assert.Equal(t, 6, len(nodes))
	}
}
