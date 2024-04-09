package test

import (
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: basicExampleDir,
		Prefix:       "appid-bas",
		Region:       validRegions[rand.Intn(len(validRegions))],
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
