--判断用户从键盘上输入的数字
set serveroutput on

--接收键盘输入 
--num: 地址值，在地址上保存了输入的数字
accept num prompt '请输入一个数字';

declare
  --定义变量，保存输入的数字
  pnum number := &num;
begin
  if pnum = 0 then dbms_output.put_line('您输入的是0');
    elsif pnum = 1 then dbms_output.put_line('您输入的是1');
    elsif pnum = 2 then dbms_output.put_line('您输入的是2');
    else dbms_output.put_line('其他数字');
  end if;    
end;
/