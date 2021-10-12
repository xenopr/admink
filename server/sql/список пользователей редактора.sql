--список пользователей
--27 09 2021 29 09 21
select
  u.id,
  u.login,
  u.username,
  u.position,
  u.subdivision,
  u.description,
  u.activeto,
  (case when sysdate>u.activeto then 0 else 1 end) active,
  (case when u.activeto is null then 0 else 1 end) activechk,
  auth.pkgauth.getUserRoles(u.id) userroles,
  auth.pkgauth.getUserRoles(u.id,'ids') userrolesids
from
  auth.usera u
where
  u.id=nvl(:userid,u.id)
order by
  lower(u.username)
