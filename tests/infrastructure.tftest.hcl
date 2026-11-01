mock_provider "gitlab" {
  mock_data "gitlab_group" {
    defaults = { id = "100" }
  }
  mock_data "gitlab_user" {
    defaults = { id = "101" }
  }
}

variables {
  gitlab_token = "mock-token"
}

run "project_settings" {
  command = plan
  module {
    source = "./modules/create_gitlab_project"
  }
  variables {
    infrastructure = {
      backend = {
        projects = {
          api   = {}
          empty = { initialize_with_readme = false }
        }
      }
    }
    group_ids = { backend = "123" }
  }
  assert {
    condition     = tostring(gitlab_project.project["backend/api"].namespace_id) == "123" && gitlab_project.project["backend/api"].default_branch == "main"
    error_message = "Projects must use the group's namespace and default branch."
  }
  assert {
    condition     = gitlab_project.project["backend/empty"].initialize_with_readme == false
    error_message = "Explicitly disabled repository initialization must be preserved."
  }
}

run "multiple_groups" {
  command = plan
  variables {
    infrastructure = {
      backend = {
        parent_group = "company"
        projects = {
          api   = {}
          empty = { initialize_with_readme = false }
        }
        members = { ivan = "developer" }
      }
      frontend = {
        projects = { api = {} }
        members  = { ivan = "maintainer" }
      }
      empty = {}
    }
  }
  assert {
    condition     = toset(keys(output.project_ids)) == toset(["backend/api", "backend/empty", "frontend/api"])
    error_message = "Projects must retain group/project keys and support repeated names."
  }
  assert {
    condition     = toset(keys(output.group_ids)) == toset(["backend", "frontend", "empty"])
    error_message = "Groups without projects or members must be supported."
  }
}

run "empty_infrastructure" {
  command = plan
  assert {
    condition     = length(output.project_ids) == 0 && length(output.group_ids) == 0
    error_message = "Default infrastructure must be empty."
  }
}
