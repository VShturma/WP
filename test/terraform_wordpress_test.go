package test

import (
        "testing"

        "github.com/gruntwork-io/terratest/modules/terraform"
)


func TestTerraformWordpress(t *testing.T) {
    t.Parallel()


    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/",

        NoColor: true,
    }


    defer terraform.Destroy(t, terraformOptions)


    terraform.InitAndApply(t, terraformOptions)
}

