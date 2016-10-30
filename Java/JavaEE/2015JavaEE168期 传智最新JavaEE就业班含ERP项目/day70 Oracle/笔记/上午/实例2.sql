/*
SQL语句
select empno,sal from emp order by sal;
--> 光标 -->  循环 --> 退出：1. 总额 > 5w  2. notfound

变量：1. 初始值  2. 最终如何得到
涨工资的人数: countemp number := 0;
涨后的工资总额： salTotal number;
1. select sum(sal) into salTotal from emp;
2. 涨后= 涨前 + sal * 0.1

练习：工资总额不能超过5w
*/
set serveroutput on
declare
  cursor cemp is select empno,sal from emp order by sal;
  pempno emp.empno%type;
  psal        emp.sal%type;
  
  --涨工资的人数: 
  countemp number := 0;
  --涨后的工资总额： 
  salTotal number;
begin
  --工资总额的初始值
  select sum(sal) into salTotal from emp;
  
  open cemp;
  loop
    --1.   总额> 5w
    exit when salTotal>50000;
  
    --取一个员工
    fetch cemp into pempno,psal;
    --2. notfound
    exit when cemp%notfound;
    
    --涨工资
    update emp set sal=sal*1.1 where empno=pempno;
    
    countemp := countemp + 1;
    
    --2. 涨后= 涨前 + sal * 0.1
    salTotal := salTotal + psal * 0.1;

  end loop;
  close cemp;
  
  commit;
  dbms_output.put_line('人数:'||countemp||'   涨后的工资总额:'||salTotal);
end; 
/
  
  
  
  
  
  
  
  
  
  
  
  
  
  