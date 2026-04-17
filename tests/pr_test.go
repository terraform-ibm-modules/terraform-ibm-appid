// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const fscloudExampleDir = "examples/fscloud"
const secureSolutionsDir = "solutions/secure"
const basicExampleDir = "examples/basic"

const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

// Current supported AppID region
var validRegions = []string{
	"jp-osa",
	"jp-tok",
	"us-east",
	"au-syd",
	"br-sao",
	"ca-tor",
	"eu-de",
	"eu-gb",
	"us-south",
}

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
		Region:       validRegions[common.CryptoIntn(len(validRegions))],
		TerraformVars: map[string]interface{}{
			"kms_key_crn":                permanentResources["hpcs_south_root_key_crn"],
			"existing_kms_instance_guid": permanentResources["hpcs_south"],
			"access_tags":                permanentResources["accessTags"],
		},
	})
	return options
}

func TestRunFSCloudExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "appid-fs", fscloudExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeSecureSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: secureSolutionsDir,
		Prefix:       "appid-fs-upg",
		Region:       validRegions[common.CryptoIntn(len(validRegions))],
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key":          options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"],
		"existing_kms_key_crn":      permanentResources["hpcs_south_root_key_crn"],
		"existing_kms_instance_crn": permanentResources["hpcs_south_crn"],
		"appid_name":                options.Prefix,
		"resource_group_name":       options.Prefix + "-rg",
	}

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestRunSecureSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: secureSolutionsDir,
		Prefix:       "appid-sol",
		Region:       validRegions[common.CryptoIntn(len(validRegions))],
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key":          options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"],
		"existing_kms_key_crn":      permanentResources["hpcs_south_root_key_crn"],
		"existing_kms_instance_crn": permanentResources["hpcs_south_crn"],
		"access_tags":               permanentResources["accessTags"],
		"appid_name":                options.Prefix,
		"resource_group_name":       options.Prefix + "-rg",
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: basicExampleDir,
		Prefix:       "appid-bas",
		Region:       validRegions[common.CryptoIntn(len(validRegions))],
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
