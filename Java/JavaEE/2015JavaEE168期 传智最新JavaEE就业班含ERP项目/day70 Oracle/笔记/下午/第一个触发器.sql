--�ɹ�������Ա�����Զ���ӡ���ɹ�������Ա����

create or replace trigger saynewemp
after insert
on emp
declare
begin
  dbms_output.put_line('�ɹ�������Ա��');
end;
/