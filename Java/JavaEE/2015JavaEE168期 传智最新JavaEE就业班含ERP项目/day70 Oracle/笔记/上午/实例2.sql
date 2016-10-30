/*
SQL���
select empno,sal from emp order by sal;
--> ��� -->  ѭ�� --> �˳���1. �ܶ� > 5w  2. notfound

������1. ��ʼֵ  2. ������εõ�
�ǹ��ʵ�����: countemp number := 0;
�Ǻ�Ĺ����ܶ salTotal number;
1. select sum(sal) into salTotal from emp;
2. �Ǻ�= ��ǰ + sal * 0.1

��ϰ�������ܶ�ܳ���5w
*/
set serveroutput on
declare
  cursor cemp is select empno,sal from emp order by sal;
  pempno emp.empno%type;
  psal        emp.sal%type;
  
  --�ǹ��ʵ�����: 
  countemp number := 0;
  --�Ǻ�Ĺ����ܶ 
  salTotal number;
begin
  --�����ܶ�ĳ�ʼֵ
  select sum(sal) into salTotal from emp;
  
  open cemp;
  loop
    --1.   �ܶ�> 5w
    exit when salTotal>50000;
  
    --ȡһ��Ա��
    fetch cemp into pempno,psal;
    --2. notfound
    exit when cemp%notfound;
    
    --�ǹ���
    update emp set sal=sal*1.1 where empno=pempno;
    
    countemp := countemp + 1;
    
    --2. �Ǻ�= ��ǰ + sal * 0.1
    salTotal := salTotal + psal * 0.1;

  end loop;
  close cemp;
  
  commit;
  dbms_output.put_line('����:'||countemp||'   �Ǻ�Ĺ����ܶ�:'||salTotal);
end; 
/
  
  
  
  
  
  
  
  
  
  
  
  
  
  