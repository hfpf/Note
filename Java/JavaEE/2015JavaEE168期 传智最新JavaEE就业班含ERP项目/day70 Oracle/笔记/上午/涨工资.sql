--涨工资，总裁1000 经理800 其他400
set serveroutput on

declare
  --员工的集合
  --alter table "SCOTT"."EMP" rename column "JOB" to empjob
  cursor cemp is select empno,empjob from emp;
  pempno emp.empno%type;
  pjob       emp.empjob%type;
begin
  rollback;

  open cemp;

  loop
    --取一个员工
    fetch cemp into pempno,pjob;
    exit when cemp%notfound;
    
    --判断职位
    if pjob = 'PRESIDENT' then update emp set sal=sal+1000 where empno=pempno;
      elsif pjob = 'MANAGER' then update emp set sal=sal+800 where empno=pempno;
      else update emp set sal=sal+400 where empno=pempno;
    end if;
  end loop;

  close cemp;
  
  --提交 ----> ACID
  commit;
  
  dbms_output.put_line('完成');
end;
/










