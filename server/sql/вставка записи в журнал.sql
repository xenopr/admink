--вставка записи в журнал
insert into auth.log l
(log.id, log.logresultid, log.logeventid, log.userid, log.token, log.restapi, log.ip, log.whence, log.target, log.operation, log.record)
values
(auth.sq_log.nextval, :logresultid, :logeventid, :userid, :token, :restapi, :ip, :whence, :target, :operation, :record)
