﻿
// Функция возвращает имя провайдера геопозиционирования в зависимости от настроек
&НаСервере
Функция ПолучитьИмяПровайдера() Экспорт
	
	Выбор = Константы.ВыборПровайдераГеопозиционирования.Получить();
	Если НЕ ЗначениеЗаполнено(Выбор) Тогда
		
	    НаборКонстант = Константы.СоздатьНабор("ВыборПровайдераГеопозиционирования,ТолькоБесплатные,ИспользоватьСотовуюСеть,ИспользоватьСетьПередачиДанных,ИспользоватьСпутники");
	    НаборКонстант.Прочитать();
		НаборКонстант.ВыборПровайдераГеопозиционирования = Перечисления.ИспользоватьПровайдерГеопозиционирования.СамыйЭкономичныйПровайдер;
		Выбор = НаборКонстант.ВыборПровайдераГеопозиционирования;
	    НаборКонстант.ТолькоБесплатные  = Истина;
	    НаборКонстант.ИспользоватьСотовуюСеть  = Истина;
	    НаборКонстант.ИспользоватьСетьПередачиДанных  = Истина;  
		
		Сообщить("Запущено получение имени провадйера!");
		
	    НаборКонстант.ИспользоватьСпутники  = Истина;
	    НаборКонстант.Записать();
		
	КонецЕсли;
	
	Структура = Новый Структура();
	Структура.Вставить("Выбор", Выбор);
	Структура.Вставить("Имя", Константы.ИмяПровайдера.Получить());
    Возврат Структура;
    
КонецФункции

&НаСервере
Функция ПолучитьПокупателей() Экспорт
	
	Покупатели = Новый Массив();
	
	// Выбираем покупателей (не больше 20) по самым свежим, не закрытым заказам
	Запрос = Новый Запрос;
	Запрос.Текст = 
	 "ВЫБРАТЬ ПЕРВЫЕ 20
	 |	Заказ.Покупатель.Широта КАК ПокупательШирота,
	 |	Заказ.Покупатель.Долгота КАК ПокупательДолгота,
	 |	Заказ.Покупатель.Ссылка КАК ПокупательСсылка,
	 |	Заказ.Покупатель.Наименование КАК ПокупательНаименование
	 |ИЗ
	 |	Документ.Заказ КАК Заказ
	 |ГДЕ
	 |	Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказов.Закрыт)
	 |	И ЕСТЬNULL(Заказ.Покупатель.Широта, 0) <> 0
	 |	И ЕСТЬNULL(Заказ.Покупатель.Долгота, 0) <> 0
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	Заказ.Покупатель.Широта,
	 |	Заказ.Покупатель.Долгота,
	 |	Заказ.Покупатель.Ссылка
	 |
	 |УПОРЯДОЧИТЬ ПО
	 |	МАКСИМУМ(Заказ.Дата) УБЫВ";
	 
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Покупатель = Новый Структура();
		Покупатель.Вставить("Наименование", Выборка.ПокупательНаименование);
		Покупатель.Вставить("Широта", Выборка.ПокупательШирота);
		Покупатель.Вставить("Долгота", Выборка.ПокупательДолгота);
		Покупатель.Вставить("Ссылка", Выборка.ПокупательСсылка);
		Покупатели.Добавить(Покупатель);
	КонецЦикла;
	Возврат Покупатели;
КонецФункции
