# Application Overview:
Simple application used for recruitement process that is written in rx swift and is showing users from 2 apis.

# Screenshots:
|  |  |
| --- | --- |
|![Simulator Screen Shot - iPhone 11 Pro - 2021-06-23 at 12 34 09](https://user-images.githubusercontent.com/51459339/123084245-34379800-d421-11eb-902a-acffcfdef05e.png)|![Simulator Screen Shot - iPhone 11 Pro - 2021-06-23 at 12 35 09](https://user-images.githubusercontent.com/51459339/123084254-3568c500-d421-11eb-950a-c82f63081616.png)|
|![Simulator Screen Shot - iPhone 11 Pro - 2021-06-23 at 12 34 11](https://user-images.githubusercontent.com/51459339/123084345-4c0f1c00-d421-11eb-9536-c342a7d31809.png)|![Simulator Screen Shot - iPhone 11 Pro - 2021-06-23 at 12 34 46](https://user-images.githubusercontent.com/51459339/123084354-4f0a0c80-d421-11eb-8641-57bf588f047a.png)|

# Recordings:

https://user-images.githubusercontent.com/51459339/123085124-32ba9f80-d422-11eb-96fd-69fb7a4fd393.mov

https://user-images.githubusercontent.com/51459339/123085137-35b59000-d422-11eb-936e-b8ba676d27e5.mov

https://user-images.githubusercontent.com/51459339/123085147-377f5380-d422-11eb-9a13-20f909bbbcb7.mov


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
