  //Debo hacer un factory constructor q recibe cierto tipo de argumentos y retorna un objeto de mi banda, el factory constructor debe llamarse igual q la clase
  //al hacerlo de esta forma, el obj es del tipo Map, recibe los parametros y devuelve un objeto de tipo Map

class Band{

  String id;
  String name;
  int votes;


  Band({
    this.id,
    this.name,
    this.votes
    
  });



  factory Band.fromMap( Map<String, dynamic> obj )
  => Band(
    id: obj.containsKey('id') ? obj['id'] : 'no-id',
    name: obj.containsKey('name') ? obj['name'] : 'no-name',
    votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes',
  );

}