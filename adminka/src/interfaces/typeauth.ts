//формат объекта ответа на запрос авторизации
export interface typeResult {
  token: string;   //токен, если выдан
  error: string;   //сообщение о причине невыдачи токена
  level: string;   //сообщение об этапе проверки запроса авторизации
}

//формат объекта запроса на авторизацию получаемым от клиента
//шифрованая строка запроса должна быть дешифруема в объект этого формата
export interface typeLogin {
  login: string;           //email пользователя в AD
  password: string;        //пароль пользователя из AD
  date: string;              //дата время создания запроса на авторизацию
}

//формат объекта токена с информацией об авторизованом пользователе отдаваемым клиенту
//строка токена должна декодироватся в объект этого формата
export interface typeToken {
  userid: number;
  login: string;
  username: string;
  subdivision: string;
  position: string;
  description: string;
  roles: string[];
  rights: string[];
}

//формат объекта возвращаемым в ответе на запрос функции REST API
export interface typeApiAnswer {
    message: string,       //сообщение
    needrights: string[],  //нужно хоть одно право из этого перечня
    banrights: string[],   //если у пользователя хоть одно право из этого перечня, доступа не будет
    tokenrights: string[], //права, которые были указаны в токене
    path: string,          //запросили путь
}

//формат отправляем на REST-сервер для редактирования роли
export interface typeEdtRole {
  name: string,
  description: string,
  rights: number[],
}

//формат отправляем на REST-сервер для редактирования пользователя
export interface typeEdtUser {
  login: string,
  username: string,
  position: string,
  subdivision: string,
  description: string,
  roles: number[],
}
