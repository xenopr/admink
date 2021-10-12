  --посмотреть журнал весь за период
  --24 09 2021
  select 
   l.id,
   l.dt,
   to_char(l.dt,'dd.mm.yy hh24:mi:ss') tstamp,
   lr.namerus namer,
   le.namerus namee,
   (case when instr(u.username,' ',-1)>0 
         then substr(u.username,1,instr(u.username,' ')-1)||substr(u.username,instr(u.username,' '),2)||'.'||substr(u.username,instr(u.username,' ',-1)+1,1)||'.' 
         else u.username end) usernameshort,
   u.username,
   l.ip,
   l.restapi,
   l.token,
   l.whence,
   l.target,
   l.operation,
   l.record
  from
    auth.log l
    join auth.logresult lr on lr.id=l.logresultid
    join auth.logevent le on le.id=l.logeventid
    left join auth.usera u on u.id=l.userid
  where
    trunc(dt) between :dtf and :dtt
    --trunc(dt) between to_date('21.09.2021','dd.mm.yyyy') and to_date('23.09.2021','dd.mm.yyyy')
  order by
   l.dt desc
