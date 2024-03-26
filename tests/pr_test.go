// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"log"
	"math/rand"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const fscloudExampleDir = "examples/fscloud"
const fscloudSolutionsDir = "solutions/fscloud"
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
		Region:       validRegions[rand.Intn(len(validRegions))],
		TerraformVars: map[string]interface{}{
			"kms_key_crn":                permanentResources["hpcs_south_root_key_crn"],
			"existing_kms_instance_guid": permanentResources["hpcs_south"],
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

func TestRunUpgradeFSCloudSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: fscloudSolutionsDir,
		Prefix:       "appid-fs-upg",
		Region:       validRegions[rand.Intn(len(validRegions))],
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key":           options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"],
		"kms_key_crn":                permanentResources["hpcs_south_root_key_crn"],
		"existing_kms_instance_guid": permanentResources["hpcs_south"],
		"prefix":                     options.Prefix,
	}

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestRunFSCloudSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: fscloudSolutionsDir,
		Prefix:       "appid-sol",
		Region:       validRegions[rand.Intn(len(validRegions))],
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key":           options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"],
		"kms_key_crn":                permanentResources["hpcs_south_root_key_crn"],
		"existing_kms_instance_guid": permanentResources["hpcs_south"],
		"prefix":                     options.Prefix,
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
