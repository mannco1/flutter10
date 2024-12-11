# Практическая работа № 10 (Программирование корпоративных систем)
выполнила: **Берлов Дмитрий Максимович**

группа: **ЭФБО-02-22**

## Описание и этапы выполнения работы
В данной работе необходимо было реализовать взаимодействие клиента (приложения) с сервером на Go через API. Осуществить хранение данных в базе данных (PostgreSQL), а также управление ими используя методы GET, POST, PUT, DELETE.

### Описание базы данных

Создал БД в PostgreSQL

```
CREATE DATABASE shop;

\c shop;

-- Создаем таблицу для пользователей
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    image TEXT,
    phone VARCHAR(50)
);

-- Создаем таблицу для продуктов
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    image TEXT,
    description TEXT,
    rules TEXT,
    age INT DEFAULT 0,
    gamers VARCHAR(50),
    game_time VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    color_ind INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создаем таблицу для избранных товаров
CREATE TABLE Favorites (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    product_id INT REFERENCES Product(product_id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id)
);

-- Создаем таблицу для корзины
CREATE TABLE Cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    product_id INT REFERENCES Product(product_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id)
);

-- Создаем таблицу для заказов
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица для продуктов в заказе (Order_Items)
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES Product(product_id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
```

![image](https://github.com/user-attachments/assets/a007e45d-d84d-47a1-9de6-20d2a10cd5fa)

Описание таблиц:
1. **Users** – хранит информацию о пользователях, такие как имя, email и пароль.
2. **Product** – хранит данные о продуктах, включая их название, описание, цену и количество на складе.
3. **Favorites** – сохраняет избранные товары пользователя.
4. **Cart** – хранит товары, добавленные пользователем в корзину.
5. **Orders** – информация о заказах, включая идентификатор пользователя, итоговую сумму и статус.
6. **Order_Items** – содержит товары из заказа, привязанные к конкретному заказу.

Для подключения к БД в моем случае используется логин **'postgres'** и пароль **'qwerty'**.

Изменить параметры подключения можно в файле **database.go** (ветка *backend* папка ***db***)

### Описание API на сервере

Для работы с API был написан сервер на Go (ветка *backend*). Описание структуры:

- **db/** : в данной папке находится файл ***database.go*** для подключения сервера к базе данных
- **models/** : описание всех структур используемых в проекте (*Product* - товар, *User* - пользователь, *Cart* - элемент корзины, *Favorite* - избранный товар)
- **handlers/** : обработка запросов GET, POST, PUT, DELETE для каждой структуры отдельно
- **main.go** : настройка роутеров

Маршруты:

```
// Роуты для продуктов
	router.GET("/products", handlers.GetProducts(db))
	router.GET("/products/:id", handlers.GetProduct(db))
	router.POST("/products", handlers.CreateProduct(db))
	router.PUT("/products/:id", handlers.UpdateProduct(db))
	router.DELETE("/products/:id", handlers.DeleteProduct(db))

	// Роуты для корзины
	router.GET("/cart/:userId", handlers.GetCart(db))
	router.POST("/cart/:userId", handlers.AddToCart(db))
	router.DELETE("/cart/:userId/:productId", handlers.RemoveFromCart(db))

	// Роуты для избранного
	router.GET("/favorites/:userId", handlers.GetFavorites(db))
	router.POST("/favorites/:userId", handlers.AddToFavorites(db))
	router.DELETE("/favorites/:userId/:productId", handlers.RemoveFromFavorites(db))
	router.GET("/favorites/:userId/:productId", handlers.IsFavorite(db))

	// Роуты для пользователя
	router.GET("/user/:userId", handlers.GetUser(db))
```

Сервер развернут на локальном хосте *127.0.0.1* для работы через эмулятор хост заменен на *10.0.0.2*

### Описание работы клиентской части

Для работы с API на клиентской части была использована библиотека ```dio```. Для этого в файле *pubspec.yaml* была добавлена следующая зависимость:

```
dio: ^5.7.0
```

**Структура проекта:**

- **lib/main.dart** : главный файл для начала работы проекта
- **lib/assets/** : папка для статических картинок (иконок)
- **lib/src/models/** : описание всех структур данных, которые используются (*User* - пользователь , *Game* - товар, *Favorite* - избранный товар, *BasketElement* - элемент корзины)
- **lib/src/ui/** : папка для элементов, связанных с отображением клиенту (*pages* - визуализация страницы, *components* - отображение элементов)
- **lib/src/recources/** : работа с dio для отправки данных на сервер (работа с API)

В ходе работы над проектом тестирование API происходило с использованием Insomnia
![image](https://github.com/user-attachments/assets/c7220fd7-304f-4850-bd55-8c64b0026e69)

**Основной функционал приложения:**

- Просмотр каталога товаров. Вывод товаров в две колонки (запрос GET). При отображении карточки товара также происходит запрос на проверку, есть ли он в избранных, для корректной отрисовки сердечка
  
<img src='https://github.com/user-attachments/assets/6d0b9a11-f9a6-487c-a8b3-6158d4073337' width = 300 />

![image](https://github.com/user-attachments/assets/bb01f21c-a7d5-4b63-adc8-79141393c4a1)

- Просмотр информации об одном товаре (GET запрос с параметром ID товара)
  
<img src='https://github.com/user-attachments/assets/16c93789-6180-43e1-a478-ab3421975da9' width = 300 />

![image](https://github.com/user-attachments/assets/add74321-99b2-482a-845f-01b8cc13ad79)

- Добавление новой игры (POST запрос)
  
<img src='https://github.com/user-attachments/assets/411fcbab-6d66-4c68-8599-c0a828cef93b' width = 300 />

<img src='https://github.com/user-attachments/assets/4271b45e-e387-4ebc-ba8c-e036116d030c' width = 300 />

![image](https://github.com/user-attachments/assets/37e2d0d5-76c8-423d-ad33-73a08f869d71)

<img src='https://github.com/user-attachments/assets/4f2868ae-950b-486d-8d2c-71ca0de2c35e' width = 300 />

- Редактирование товара через страницу информации о товаре (PUT запрос)

<img src='https://github.com/user-attachments/assets/ce4f8035-a5a4-4818-b47e-f8fd65b129ee' width = 300 />

<img src='https://github.com/user-attachments/assets/5e8e285c-1f76-4651-aff6-b723b9c35fe3' width = 300 />

<img src='https://github.com/user-attachments/assets/52281bab-bb55-4cb1-add1-1b4bfa7d767c' width = 300 />

![image](https://github.com/user-attachments/assets/6d693bd4-683e-4f61-8e4c-ef3e01f19f7e)

- Удаление товара через карточку товара (DELETE запрос)

<img src='https://github.com/user-attachments/assets/b6497dd2-eba7-427c-8ac2-586ea35a2fdf' width = 300 />

<img src='https://github.com/user-attachments/assets/5b39f4e8-b999-4ebb-9e7b-ae9a8927a5b5' width = 300 />

![image](https://github.com/user-attachments/assets/e50dd4b4-892c-40af-a776-e8f2aadbf3a4)

- Получение избранных товаров (GET запрос по ID пользователя)

<img src='https://github.com/user-attachments/assets/00c8fb7a-c38f-4353-a3d8-5df662b34c36' width = 300 />

<img src='https://github.com/user-attachments/assets/a38ec460-0200-4a20-a13b-b84ae9e882a9' width = 300 />

![image](https://github.com/user-attachments/assets/8d52aa46-725b-4761-81c0-50a725e70abe)

![image](https://github.com/user-attachments/assets/e4d048dc-f5e0-44b1-9a3c-b689380189a9)

- Добавление товара в избранное (POST запрос)

<img src='https://github.com/user-attachments/assets/e22e8b33-94e7-493a-b26a-debee81437b4' width = 300 />

![image](https://github.com/user-attachments/assets/b4c5f9b1-7b60-451c-88a7-35121bc36680)


- Удаление товара из избранного (DELETE запрос)

<img src='https://github.com/user-attachments/assets/4d1732b4-7ddb-4dfb-bc20-da715f5c8ca0' width = 300 />

<img src='https://github.com/user-attachments/assets/b0172937-31a6-4aed-b99e-b3783c1af5d7' width = 300 />

![image](https://github.com/user-attachments/assets/78d5dd18-4f76-45e0-b316-57127c523635)

- Просмотр корзины. Вывод товаров на странице корзина (GET запрос по ID пользователя)
<img src='https://github.com/user-attachments/assets/af80d988-ac25-4bf2-b901-75cc1e132ebd' width = 300 />

<img src='https://github.com/user-attachments/assets/8d16185e-2ade-48e7-92a6-1a762eb09273' width = 300 />

![image](https://github.com/user-attachments/assets/ac2b45c8-4944-4448-a03b-ee05f2fab7f5)

- Добавление товара в корзину (POST запрос)

<img src='https://github.com/user-attachments/assets/5e72b00b-31ff-4d0d-9b8e-ec21618d3c66' width = 300 />

![image](https://github.com/user-attachments/assets/2c730711-374d-469c-a6f4-0d7525361ba7)

<img src='https://github.com/user-attachments/assets/04649656-4ddf-4f8a-a6d6-fec133d59446' width = 300 />

![image](https://github.com/user-attachments/assets/3e4430d6-ec86-4117-8732-60d671f9b785)

- Удаление товара из корзины (DELETE запрос)

<img src='https://github.com/user-attachments/assets/62670b86-94c7-432c-9a48-d1d965310fb1' width = 300 />

<img src='https://github.com/user-attachments/assets/daa33d6a-40ad-4db6-9a8b-4c196f708321' width = 300 />

![image](https://github.com/user-attachments/assets/e52b4083-c787-46c7-a396-bffd409ce60a)

- Просмотр и получение данных пользователя на странице Профиль (GET запрос по ID пользователя)

<img src='https://github.com/user-attachments/assets/a29ef9a8-c2e3-4b3a-b61b-a6704ba58fa1' width = 300 />

![image](https://github.com/user-attachments/assets/959a9eea-e9aa-43a8-bec9-c553380b4a8e)
#   f l u t t e r 1 0  
 