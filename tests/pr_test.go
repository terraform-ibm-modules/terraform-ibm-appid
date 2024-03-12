// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const completeExampleDir = "examples/complete"
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix,
		Region:       "us-south", // Locking to "us-south" as the permanent KMS instance is located in us-south
		TerraformVars: map[string]interface{}{
			"kms_key_crn":                permanentResources["kp_us_south_root_key_crn"],
			"existing_kms_instance_guid": permanentResources["kp_us_south_guid"],
		},
	})
	return options
}

func TestRunCompleteExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "mod-template", completeExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

//func TestRunUpgradeExample(t *testing.T) {
//	t.Parallel()
//
//	options := setupOptions(t, "mod-template-upg", completeExampleDir)
//
//	output, err := options.RunTestUpgrade()
//	if !options.UpgradeTestSkipped {
//		assert.Nil(t, err, "This should not have errored")
//		assert.NotNil(t, output, "Expected some output")
//	}
//}
