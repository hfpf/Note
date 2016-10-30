--查询某个员工的年收入
create or replace function queryempincome(eno in number)
return number
as
  --月薪和奖金
  psal emp.sal%type;
  pcomm emp.comm%type;
begin
  select sal,comm into psal,pcomm from emp where empno=eno;

  --返回年收入
  return psal*12+nvl(pcomm,0);
end;
/