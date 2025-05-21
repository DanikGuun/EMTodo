# (Swift 6, iOS 15+): MVC, UIKit, SnapKit, GCD, Notification Center, XCTest, Сore Data, Core Graphics, Core Animation

<br>

<img src="https://github.com/user-attachments/assets/93c6cf0d-024a-4b24-b7af-fe4f98d91fd7" width="250">!
<img src="https://github.com/user-attachments/assets/b688c6c5-b7db-4b74-8bad-c956f62b7678" width="250">!
<img src="https://github.com/user-attachments/assets/a2792d37-053f-47b5-9093-71b1d53c0e1d" width="250">!
<img src="https://github.com/user-attachments/assets/a5bb5c20-c399-4867-9ef5-84417c9f19d2" width="250">!
<img src="https://github.com/user-attachments/assets/09caedf0-7466-42e5-b59a-df7afd25f80e" width="250">!
<img src="https://github.com/user-attachments/assets/15f388c1-94ab-4b0a-a5a6-198994becd87" width="250">!

<br>

<h1>Тестовое задание в Effective Mobile</h1>
<p>В целом я доволен реализацией. Простое приложение, моментами может показаться, что из пушки по воробьям стрелял))</p> <p>Но Ведь цель тестового - показать что умеешь, а не сделать экономно)</p>

<h2>Из интересного:</h2>
<ul>
  <li>Асинхронная работа с хранилищем</li>
  <li>Возможность поделиться задачей</li>
  <li>Высокий уровень абстракции. Всё что инкапсулируется - инкапсулировано</li>
  <li>Вёрстка на чистом UIKit без StoryBoard</li>
  <li>Подгрузка моковых задач при первом запуске</li>
  <li>Самописный чекмарк с анимацией для задачек</li>
  <li>Фильтрация задач по словам и типу(завершена/нет)</li>
</ul>

<h1>Структура</h1>

<h2>Координатор</h2>
  <p>Не бигтеховский координатор - его младщий брат) Но свою задачу - инкапсуляцию навигации выполняет</p>

  <h3>Coordinatable</h3>
    <ul>
      <li type="cirlce">Может быть подписан только под UIViewController'ом</li>
      <li type="cirlce">Имеет ссылку на координатор, чтобы управлять навигацией</li>
    </ul>

  <h3>Coordinator</h3>
    <ul>
      <li type="cirlce">Методы собственно для отображения контроллеров</li>
      <li type="cirlce">ViewControllersFactory - фабрика, с которой берутся сами контроллеры</li>
    </ul>
  
<h2>Фабрика контроллеров</h2>
  <p>Фабрика для контроллеров, чтобы все знали, что они создаются, но никто не знал как🤫</p>
  
  <h3>ViewControllersFabric</h3>
    <ul>
      <li type="cirlce">Методы для создания контроллеров</li>
      <li type="cirlce">ModelsFactory - фабрика, с которой берутся модели для контроллеров🧐</li>
    </ul>

<h2>Фабрика моделей</h2>
  <p>Фабрика для моделей, чтобы(опять?) все знали, что они создаются, но никто не знал как🤫</p>
  
  <h3>ModelsFactory</h3>
    <ul>
      <li type="cirlce">Методы для создания моделей)</li>
      <li type="cirlce">TaskManager - обращалка к хранилищу задачами и снова все знают что делает, но не знают как🥲</li>
    </ul>
  
<h2>Менеджер для задач</h2>
  <p>Не ещё одна фабрика? ДА!</p>
    <h3>TaskManager</h3>
    <ul>
      <li type="cirlce">Стандартный набор CRUD</li>
      <li type="cirlce">Реализован посредством замыканий и GCD -> не тормозит UI при обращении🎉</li>
    </ul>

  <h2>Экран со списком задач</h2>
  <p>Наконец, ближе к делу</p>
    <h3>TaskListModel</h3>
    <ul>
      <li type="cirlce">Конечено же CRUD посредник между TaskManager и TaskListViewController</li>
      <li type="cirlce">Можно получить текстовое описание для задачи</li>
      <li type="cirlce">Получить склоненную строку с количеством задач</li>
      <li type="circle">Фильтрация задач по слову, типу</li>
    </ul>
    <h3>TaskListController</h3>
    <ul>
      <li type="cirlce">TaskListPresenter - отображение для писка задач📋</li>
      <li type="cirlce">Строка поиска/фильтрации</li>
      <li type="cirlce">Тулбар с надписью о количестве задач и кнопкой для создания новой</li>
    </ul>
    <h3>TaskListTableView: TaskListPresenter</h3>
    <ul>
      <li type="cirlce">Таблица для отображения задач</li>
      <li type="cirlce">Ячейки имеют контесктное меню</li>
      <li type="cirlce">Удаление свайпом</li>
      <li type="cirlce">DiffableDataSource</li>
      <li type="cirlce">Связь с контроллером через делегт</li>
    </ul>

  <h2>Экран создания/редактирования задачи</h2>
  <p>Второй(последний) экран</p>
    <h3>TaskEditingModel</h3>
    <ul>
      <li type="cirlce">Тоже посредник между TaskManager и TaskEditingViewController</li>
      <li type="cirlce">Может выполнить действие с задачей</li>
      <li type="cirlce">И выдать начальную информацию для заполнения</li>
      <li type="circle">TaskAddModel, TaskEditModel - реализации для создания/редактирования задач</li>
    </ul>
    <h3>TaskEditingViewController</h3>
    <ul>
      <li type="cirlce">Простой котнроллер с полями для названия и опсания задачи</li>
      <li type="cirlce">Popover контроллер для выбора даты задания</li>
      <li type="cirlce">Просто и со вкусом>li>
    </ul>
    <h3>TaskListTableView: TaskListPresenter</h3>
    <ul>
      <li type="cirlce">Таблица для отображения задач</li>
      <li type="cirlce">Ячейки имеют контесктное меню</li>
      <li type="cirlce">Удаление свайпом</li>
      <li type="cirlce">DiffableDataSource</li>
      <li type="cirlce">Связь с контроллером через делегт</li>
    </ul>

  <h2>Загрузка моковых задачек</h2>
  <p>Последнее</p>
    <h3>InitialTaskLoader</h3>
    <ul>
      <li type="cirlce">Происходит при первом запуске приложения</li>
      <li type="cirlce">Обошлись без протоколов, ибо используется только один раз и только в одном месте. Не от кого скрываться)</li>
      <li type="cirlce">После получения задач они добавляются через TaskManager и публикуется уведомление в NotificationCenter о том, что задачи подгрузили</li>
    </ul>

<h1>Заключение</h1>
<p>Вот и всё. На самом деле, влил свою джуновскую архитекторскую душу в это)</p>
<p>Буду рад любой адекватной(опционально) критике</p>
<p>Места, которые разумно тестировать - покрыл тестам конечно же))</p>
<p>Я считаю, что получилось довольно хорошо, модульный и слабосвязный код с композицией вместо наследования - это ли не счастье?</p>
  
