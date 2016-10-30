--查询并打印50号部门的员工姓名
set serveroutput on

declare
  cursor cemp is select ename from emp where deptno=50;
  pename emp.ename%type;
  
  --自定义例外
  no_emp_found exception;
begin
  open cemp;
  
  --取一条记录
  fetch cemp into pename;
  
  if cemp%notfound then 
    --抛出例外
    raise no_emp_found;
  end if;  
  
  --自动启动进程：pmon(process monitor) 清理现场
  close cemp;

exception
  when no_emp_found then dbms_output.put_line('没有找到员工');
  when others then dbms_output.put_line('其他例外');
end;
/









