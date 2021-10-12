--запрос перечн€ прав пользовател€
--дл€ auth
--протасов аа
--11 08 2021
--03 09 2021
select 
   u.*,
   auth.pkgauth.getUserRoles(u.id) userroles,
   auth.pkgauth.getUserRights(u.id) userrights,
   (case when sysdate>u.activeto then 0 else 1 end) active
 from
   auth.usera u           
where
--   lower(u.login)=lower(:loginname)
--   lower(u.login)=lower('Protasovaa@zsniigg.ru')
   lower(u.login)=lower('ZamaraevVv@zsniigg.ru')
--   lower(u.login)=lower(:loginname)
   

   
