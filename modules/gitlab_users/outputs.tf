output "user_ids" {
    description = "Получение идентификаторов пользователей GitLab на основе их имен пользователей"
    value = {
        for name, user in data.gitlab_user.users : 
        name => user.id
    }  
}