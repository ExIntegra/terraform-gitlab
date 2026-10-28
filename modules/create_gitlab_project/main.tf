resource "gitlab_project" "project" {
  name             = var.project.name
  path             = var.project.path
  description      = var.project.description
  namespace_id     = var.project.namespace_id
  default_branch   = var.project.default_branch
  merge_method     = var.project.merge_method
  visibility_level = var.project.visibility_level

  lifecycle {
    precondition {
      condition     = !var.project.use_custom_template || var.project.temp_name != null
      error_message = "Если use_custom_template = true, должно быть указано имя шаблона в temp_name"
    }
  }

  provisioner "local-exec" {
    when        = create
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
    environment = {
      SRC          = replace("${var.gitlab_url}/${var.temp_path}/${var.project.temp_name}.git", "https://", "https://oauth2:${var.import_token}@")
      DST          = replace(self.http_url_to_repo, "https://", "https://oauth2:${var.import_token}@")
      USE_TEMPLATE = var.project.use_custom_template ? "true" : "false"
    }
    command = <<-EOT
      if ($env:USE_TEMPLATE -ne "true") { exit 0 }
      $tmp = Join-Path $env:TEMP ("seed-" + [guid]::NewGuid())
      git clone $env:SRC $tmp
      if ($LASTEXITCODE -ne 0) { throw "Не удалось склонировать шаблон" }
      Set-Location $tmp
      git remote add target $env:DST
      git push target --all
      if ($LASTEXITCODE -ne 0) { throw "Не удалось залить код в проект" }
      git push target --tags
      Set-Location $env:TEMP
      Remove-Item -Recurse -Force $tmp
    EOT
  }
}
