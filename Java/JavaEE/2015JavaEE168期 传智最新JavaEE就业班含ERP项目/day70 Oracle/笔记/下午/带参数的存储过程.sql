--��ָ����Ա����100�����Ҵ�ӡ��ǰ���Ǻ��нˮ
create or replace procedure raiseSalary(eno in number)
as
  --�������������ǰ��нˮ
  psal emp.sal%type;
begin
  select sal into psal from emp where empno=eno;

  update emp set sal = sal+100 where empno=eno;
  
  --Ҫ��Ҫcommit�� һ�㲻Ҫ
  
  dbms_output.put_line('��ǰ:'||psal||'   �Ǻ�'||(psal+100));

end;
/