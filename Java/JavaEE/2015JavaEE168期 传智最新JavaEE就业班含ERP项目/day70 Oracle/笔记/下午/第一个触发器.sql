--成功插入新员工后，自动打印“成功插入新员工”

create or replace trigger saynewemp
after insert
on emp
declare
begin
  dbms_output.put_line('成功插入新员工');
end;
/