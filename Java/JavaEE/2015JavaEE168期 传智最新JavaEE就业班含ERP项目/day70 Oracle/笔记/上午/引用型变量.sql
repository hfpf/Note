--查询并打印7839的姓名和薪水
set serveroutput on

declare
  --定义变量保存姓名和薪水
  --pename varchar(20);
  --psal       number;
  pename emp.ename%type;
  psal        emp.sal%type;
begin
  --得到姓名和薪水
  select ename,sal into pename,psal from emp where empno=7839;
  dbms_output.put_line(pename||'的薪水是'||psal);
end;
/