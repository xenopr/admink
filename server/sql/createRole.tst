PL/SQL Developer Test script 3.0
9
declare
  -- Non-scalar parameters require additional processing 
  v_rights pkgauth.typeids:=pkgauth.typeids(1,2);
begin
  -- Call the function
  :result := PKGAUTH.createRole(v_name => :v_name,
                                v_description => :v_description,
                                v_rights => v_rights);
end;

