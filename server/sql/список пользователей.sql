--список пользователей
--15 09 2021
select 
   u.id,
   u.login,
   u.activeto,
   u.username,
   u.position,
   u.subdivision,
   u.description,
   auth.pkgauth.getUserRoles(u.id) userroles,
   auth.pkgauth.getUserRights(u.id) userrights,
   (case when sysdate>u.activeto then 0 else 1 end) active
 from
   auth.usera u 
order by
   lower(u.login)
