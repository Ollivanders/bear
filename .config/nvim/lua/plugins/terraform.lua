return {
  "mvaldes14/terraform.nvim",
  ft = "terraform",
  opts = {
    cmd = "grep", -- Options: grep or rg
    program = "terraform", -- Options: terraform or opentofu
  },
  init = function()
    local map = vim.keymap.set

    map("n", "<leader>tp", ":TerraformPlan", { silent = true, desc = "Terraform Plan" })
    map("n", "<leader>te", ":TerraformExplore", { silent = true, desc = "Terraform Explore" })
    map("n", "<leader>tv", ":TerraformValidate", { silent = true, desc = "Terraform Validate" })
    map("n", "<leader>ti", ":TerraformInit", { silent = true, desc = "Terraform init" })
  end,
}
