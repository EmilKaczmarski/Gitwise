# Application Requirements:

Using the Swift language, write an application that meets the following requirements:
  
  ● It consists of 2 screens: one with a list of items and one with details after selecting
    list item.
  
  ● The application retrieves the data displayed in the list from 2 different APIs:
    
    a. Bitbucket:
      https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description
    
    b. GitHub:
      https://api.github.com/repositories
  
  ● The list item consists of: repository name, user name and owner avatar.
  
  ● The details screen contains: repository name, user name and owner avatar, and repository description.
  
  ● Items downloaded from the Bitbucket API should be highlighted (in any way).
  
  ● The list has the ability to enable or disable sorting of items in alphabetical order (by repository name).
  
  ● Pagination is not required.
  
  Nive to have:
  
  ● use of an architectural pattern of choice (MVP, MVVM, etc.),
  
  ● use of a reactive approach (RxSwift),
    protection of the application in case of lack of access to the Internet (any
    solution: message/possibility of reloading views/data caching).


------------------------------
**ORIGINAL description (pl):**

Używając języka Swift, napisać aplikację spełniającą następujące wymagania:
  
  ● Składa się z 2 ekranów: z listą elementów oraz ze szczegółami po wybraniu
  elementu listy.
  
  ● Aplikacja pobiera dane wyświetlane na liście z 2 różnych API:
    
    a. Bitbucket:
      https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description
    
    b. GitHub:
      https://api.github.com/repositories
  
  ● Element listy składa się z: nazwy repozytorium, nazwy użytkownika i avatara właściciela.
  
  ● Ekran ze szczegółami zawiera: nazwę repozytorium, nazwę użytkownika i avatar właściciela oraz opis repozytorium.
  
  ● Elementy pobrane z API Bitbucket powinny być wyróżnione (w dowolny sposób).
  
  ● Lista ma możliwość włączenia lub wyłączenia sortowania elementów w kolejności alfabetycznej (po nazwie repozytorium).
  
  ● Paginacja nie jest wymagana.
  
  Mile widziane:
  
  ● wykorzystanie wybranego wzorca architektonicznego (MVP, MVVM itp.),
  
  ● wykorzystanie podejścia reaktywnego (RxSwift),
  
  ● zabezpieczenie aplikacji w przypadku braku dostępu do Internetu (dowolne
  rozwiązanie: komunikat/możliwość przeładowania widoków/cache’owanie danych).
