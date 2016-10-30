--查询并打印员工的姓名和薪水
/*
1.  光标的属性
      %isopen      %rowcount (影响的行数)
      %found       %notfound

*/
set serveroutput on
declare
  -- 定义光标
  cursor cemp is select ename,sal from emp;
  pename emp.ename%type;
  psal       emp.sal%type;
begin
  --打开光标
  open cemp;
  
  loop
    --取一条记录
    fetch cemp into pename,psal;
    --exit when 没有取到记录;
    exit when cemp%notfound;

    dbms_output.put_line(pename||'的薪水是'||psal);

  end loop;
  
  --关闭光标
  close cemp;
end;
/