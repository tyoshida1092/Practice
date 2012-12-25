global class TY_RemoteAction {
  public TY_RemoteAction() {
  }

  @remoteAction
  global static String sayHello(String name) {
    return 'Hello ' + name + '!';
  }
   
  @remoteAction
  global static String getString() {
    return 'あいうえお';
  }
   
  @remoteAction
  global static String getHTML() {
    return '<span style="color: RED;">red</span>';
  }
   
  @remoteAction
  global static Integer getInteger() {
    return 1;
  }
   
  @remoteAction
  global static Boolean getBoolean() {
    return true;
  }
   
  @remoteAction
  global static SObject[] getSObjects(String name) {
    return Database.query('select Id, Name from ' + name + ' limit 10');
  }
   
  @remoteAction
  global static ResultClass getUserDefinedClass() {
    return new ResultClass();
  }
   
  @remoteAction
  global static ResultEnum getUserDefinedEnum() {
    return ResultEnum.value2;
  }
   
  @remoteAction
  global static void errorAction() {
    throw new RemoteActionException('えらー');
  }
  global class ResultClass {
    public String value { get; private set; }
    public ResultClass() {
      value = 'result';
    }
  }
  global enum ResultEnum {
    VALUE1, VALUE2, VALUE3
  }
  class RemoteActionException extends Exception{}
}