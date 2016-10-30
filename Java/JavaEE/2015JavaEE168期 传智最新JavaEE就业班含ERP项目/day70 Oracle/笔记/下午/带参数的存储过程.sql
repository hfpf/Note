--给指定的员工涨100，并且打印涨前和涨后的薪水
create or replace procedure raiseSalary(eno in number)
as
  --定义变量保存涨前的薪水
  psal emp.sal%type;
begin
  select sal into psal from emp where empno=eno;

  update emp set sal = sal+100 where empno=eno;
  
  --要不要commit？ 一般不要
  
  dbms_output.put_line('涨前:'||psal||'   涨后：'||(psal+100));

end;
/