--被0除
set serveroutput on

declare 
  pnum number;
begin
  pnum := 1/0;

exception
  when zero_divide then dbms_output.put_line('1:0不能做被除数');
                                         dbms_output.put_line('2:0不能做被除数');
  when value_error then dbms_output.put_line('算术或者转换错误');
  when others then dbms_output.put_line('其他例外');
end;
/