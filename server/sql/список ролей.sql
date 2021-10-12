--список ролей
--15 09 2021 220921
select
  r.id,
  r.name,
  r.description,
  auth.pkgauth.getRoleUsers(r.id) roleusers,
  auth.pkgauth.getRoleRights(r.id) rolerights,
  auth.pkgauth.getRoleRights(r.id,'ids') rolerightsids
from
  auth.role r
where
  r.id=nvl(:roleid,r.id)
order by
  lower(r.name)
