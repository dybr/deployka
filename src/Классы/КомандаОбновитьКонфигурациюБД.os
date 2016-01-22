
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
    ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Обновление конфигурации базы данных");
    
    Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "СтрокаПодключения", "Строка подключения к рабочему контуру");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
    	"-db-user",
    	"Пользователь информационной базы");

    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
    	"-db-pwd",
    	"Пароль пользователя информационной базы");

    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
    	"-v8version",
    	"Маска версии платформы 1С");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, 
    	"-allow-warnings",
    	"Маска версии платформы 1С");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
    
	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();
	
    СтрокаПодключения = ПараметрыКоманды["СтрокаПодключения"];
	Пользователь      = ПараметрыКоманды["-db-user"];
	Пароль            = ПараметрыКоманды["-db-pwd"];
	ПредупрежденияВозможны = ПараметрыКоманды["-allow-warnings"];
	ИспользуемаяВерсияПлатформы = ПараметрыКоманды["-v8version"];
	
    Если ПустаяСтрока(СтрокаПодключения) Тогда
		Лог.Ошибка("Не задана строка подключения");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;
	
	Конфигуратор = Новый УправлениеКонфигуратором;
	Конфигуратор.КаталогСборки(КаталогВременныхФайлов());
	Конфигуратор.УстановитьКонтекст(СтрокаПодключения, Пользователь, Пароль);
	Если ИспользуемаяВерсияПлатформы <> Неопределено Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ИспользуемаяВерсияПлатформы);
	КонецЕсли;
	
	Лог.Информация("Запускаю обновление конфигурации БД");
	Попытка
		Конфигуратор.ОбновитьКонфигурациюБазыДанных(Не ПредупрежденияВозможны);
		Текст = Конфигуратор.ВыводКоманды();
		Если Не ПустаяСтрока(Текст) Тогда
			Лог.Информация(Текст);
		КонецЕсли;
	Исключение
		Лог.Ошибка(Конфигуратор.ВыводКоманды());
		Возврат ВозможныйРезультат.ОшибкаВремениВыполнения;
	КонецПопытки;
	
	Возврат ВозможныйРезультат.Успех;
    
КонецФункции

Лог = Логирование.ПолучитьЛог("vanessa.app.deployka");