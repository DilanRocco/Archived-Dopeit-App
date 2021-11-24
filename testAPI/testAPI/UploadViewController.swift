//
//  UploadViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/8/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
class UploadViewController: UIViewController {
    var documentdata:[String:Any] = ["":""]
    
    var question1Q:[String] = []
    var answer1Q:[String] = []
    var answer2Q:[String] = []
    var answer3Q:[String] = []
    var answer4Q:[String] = []
    var correctAnswerQ:[Int] = []

    var timer = Timer()
 
    var correctAnswerTFD:[Int] = []
    var explanationTFD:[String] = []
    var questionTFD:[String] = []
    
    var userPoints:[Int] = []
    var userUID: [String] = []
    //Multiple Choice
    let question = ["Which president agreed to drop the first Atomic Bomb over Hiroshima?","In the United States, which state was the last state to overturn laws against interracial marriage?","Which Asian country had seven of the ten deadliest wars in human history?","Which country was once known as the Otoman Empire?","When did the construction of the Berlin Wall begin?","When did the Great fire of London happen?","World War one started?","What happened on April 14th, 1912?","Confucius was?","How long did the Revolutionary war last?","How long did the 100 year war last?","In what year was John F. Kennedy assassinated?","Greenland was a colony of which country until 1981?","Which battle took place on Saturday, July 18th, 1815?","Which world leader is famous for his /”Little Red Book/”?","Who wrote the Communist Manifesto?","When was slavery abolished in the Untied States?","Who became the first man to walk on the moon?","Who invented the Cotton Gin?","What year did the war of 1812 end?","Which Greek historian is known as the /”Father of History/”?","Which prison was stormed on July 14th, 1789?","Which war took place between 1950 and 1953?","Which century did the French Revolution take place?","In which war did the Battle of the Bulge take place?","When was Pearl Harbor bombed?","The Cuban Revolution led to the rise of what dictator?","How many U.S. presidents have been assassinated?","The Holocaust was between?","What is the name of the first human civilization?","How many terms did George Washington serve as the president of the United States?","Who was the second president of the United States?","In which European country was there a Civil War between 1946 and 1949?","Which war was fought in South Africa between 1899 and 1902?","Which is the world’s oldest country?","What was the Largest Contiguous Empire in history?","How many people died on D Day?","How long was the Indo-Pakistan war?","Who was the city of Alexandria, Egypt named after?","Which country did the USSR invade in 1979?","Which country is the world’s oldest functioning democracy?","Who was Pnacho Villa?","How was the plague brought to Europe in 1347?","When was the Freedmen’s Bureau Bill put into law?","Which U.S. president was shot outside the Hilton Hotel?","What is Alexander Hamilton best known for?","Who is the father of Turkish democracy?","Who is the principal author of the Declaration of Independence?","Kristallnacht is known as and the start of ?","Who was assassinated on April 4th, 1968?","In which state did historical oversight, noted in 2013, that the thirteen amendment was not officially ratified as an end to slavery?","Who was the first Queen of England?","The Incan Empire is located in which modern day country?","Who was the first democratically elected President of Russia?","Which of the following empires had no written language?","who was the first U.S. president to be impeached?","When was the world’s first postage stamp introduced?","Which war involved major battles fought at Fort Sumter and Shiloh?","Which war lasted about 38 minutes?","In which ocean was the Battle of Midway fought?","Who is generally considered the “/Father of History/”?","Who was a primary force behind the Reign of Terror?","Which city is known as the Islamic Holy Land?","When did the Great Depression begin?","The Nazi invasion of which country triggered World War II in Europe?","The Treaty of Versailles followed which war?","Who was the first American casualty in the American Revolutionary War?","The Great Leap Forward in China was designed to?","Who fought in the War of 1812?","What year did the California Gold Rush start?","Who was Germany’s first woman Chancellor?","When was Hong Kong given back to China?","Which U.S. president proposed the “/New Deal/”?","Which Mesoamerican civilization was known for its hieroglyphic script?","When did Hitler come to power?","What was the goal of the Marshall Plan?","Which president first created a law to destroy the Klu Klux Klan?","When was the Boston Tea Party?","Which other country besides the United States had Japanese internment camps?","What was the Manhattan Project?","When was the Declaration of Independence signed?","Which historical figure lived between the years of 1815 and 1898?","Who was the first Western explorer to reach China?","Idi Amin led a military coup in which country?","What is the name of the famous battle in which Napoleon was defeated?","The assassination of what political leader helped to trigger the start of World War I?","The Battle of Hastings was fought in which country?","Which was the first dynasty in China>","Where did the Industrial Revolution begin?","How many days a week were there in Ancient Roman times?","When did Aparhtied start?","Who served as the president of South Africa from 1994 to 1999?","What is Mahatma Gandhi known for?","When Martin Luther King’s /”I Have a Dream/” speech?","What is the famous battle of 1346?","Who became the president of the U.S. after Lincoln was assassinated?","What was considered  the largest naval battle of World War I?","How many U.S. presidents have been assassinated?","Where did Joan of Arc die?","which disease killed hundreds of people in 1832 glasgow?"]
          let Answer1 = ["Harry Truman","Mississippi","Cambodia","Hungary","1954","1666","After a terrorists attack on Austria","The Prime Minister of Russia was shot","A statue in China representing peace","5 years","110 years","1960","Denmark","The Battle of Okinawa","Karl Marx","Joseph Stalin","1840","Neil Armstrong","Henry Clay","1815","Aeschylus","Alcatraz","Korean War","The 19th Century","Gulf War","December 7, 1930","Fidel Castro","5","1939 to 1942","Mesopotamia","2 terms","Aaron Burr","Poland","Battle of Majuba Hill","San Marino","Seljuk Empire","5,344","70 days","Alexander the Great","Iraq","Finland","A leader in present day Mexico","It came from Fleas and Rodents from Britain","1865","Gerald Ford","He was vice president under George Washington","Adnan Menderes","Alexander Hamilton","The start of World War II","Jacob Zuma","Georgia","Mary I","Guatemala","Mikhail Gorbachev","Roman Empire","Andrew Johnson","1860","American Civil War","Sero-Bulgarian War","Indian Ocean","Xenophon","George Bataille","Karachi","October 24, 1929","Netherlands","American Civil War","John Bacon","Create active rapid Industrialization"," Russia and Germany","1848","Beatrix Von Storch","1991","Aaron burr","Inca Civilization","1929","To end World War II","Robert E Lee","January 16, 1774","Canada","Project to acquire more low income housing","1766","Grigori Rasputin","James Cook","Papua New Guinea","Battle of Waterloo","Boutros Ghai","England","Shang Dynasty","England","9 Days","1968","Cyril Ramaphosa","Being a women's rights activist in Pakistan","August 28, 1963","Battle of Lipany","Richard Nixon","Battle of Coronel","4","Lyon, France","Antonine Plague"]
     
          let Answer2 = ["Franklin D. Roosevelt","Texas","Vietnam","Turkey","1964","1700","After the assaionation of Archduke Franz Ferdinand","The Great fire of Paris started","A Chinese war hero","4 years","50 years","1963","France","The Battle of Agincourt","Mao Zedong","Immanuel Kant","1865","Yuri Gagarin","Henry Bessemer","1813","Sophocles","Millbank Prison","Cold War","The 18th Century","Mexican American War","December 7, 1941","Che Guevara","2","1938 to 1945","Eurphrates","3 terms","John Adams","Austria","Mahdist War","Monaco","Spanish Empire","2,000","17 days","Aristotle","Saudi Arabia","Iceland","A Brzailian Revolutionary leader","It was brought in from Greece","1867","Ronald Reagan","He fought in the Civil War","Fevzi Çakmak","Abraham Lincoln","The night of broken glass and the start of jewish persecution in Germany","Malcolm X","Alabama","Elizabeth I of England","Peru","Vladimir Putin","Aztec Empire","Bill Clinton","1780","War of 1812","Anglo-Zanzibar War","Southern Ocean","Herodotus","Marquis de Sade","Mecca","December 10, 1941","Denmark","Vietnam War","Crispus Attucks","Establish military dominance","Spain and England","1812","Janet Yellen","1998","Franklin D. Roosevelt","Olmec Civilization","1930","To end World War I","Ulysses S. Grant","January 16, 1778","Australia","Project to help low income families","1776","Mohandas Gandhi","Sir Francles Drake","Uganda","Battle of Rolica","Czar Nicholas I","France","Zhou Dynasty","France","8 Days","1934","Nelson Mandela","Leading Pakistan to independence by way of nonviolent protests","September 3, 1963","Battle of Castillon","Harry S. Truman","Battle of Jutland","6","Rouen, France","Spanish Flu"]
         let Answer3 = [ "Herbert Hoover","Virginia","China","Russia","1978","1668","After the assaionation of Philippe Pétain","World War two started","A Chinese philosopher and thinker","7 years","100 years","1970","Scotland","The Battle of Somme","Zhou Enlai","Karl Marx","1875","Gene Cernan","Robert Fulton","1812","Herodtus","Old Melbourne Gaol","Gulf War","The 17th Century","World War I","December 7, 1951","Fulgencio Batista","4","1945 to 1950","Persian Empire","1 terms","Thomas Jefferson","Greece","Anglo-Zulu War","Luxembourg","Mongol Empire","3,200","1 years","Alexander Khan","Turkey","Norway","A Mexican Revolutionary leader","It was brought in from Rome","1870","John F. Kennedy","He led the treasury department under George Washington","Recep Tayyip Erdoğan","Thomas Jefferson","The start of World War I in Germany","President John F. Kennedy","Mississippi","Anne Boleyn","Brazil","Nikita Krushchev","Incan Empire","Richard Nixon","1840","World War II","Falklands War","Pacific Ocean","Aristotle","Napoleon Bonaparte","Tehran","April 20, 1929","Poland","World War II","Daniel Hough","Promote capitalism","Great Britain and the United States","1902","Maria Blum","1985","Harry S. Truman","Maya Civilization","1936","To aid war torn countries","Andrew Johnson","December 16, 1774","New Zealand","Project to help Manhattan come out of the Great Depression","1780","Thomas Jefferson","Marco Polo","Angola","Battle of Stalingrad","Archduke Franz Ferdinand","Norway","Qin Dynasty","Germany","7 Days","1922","Jacob Zuma","Leading India to independence by way of nonviolent protests","August 28, 1964","Battle of Crecy","Thomas Jefferson","Battle of Somme","3","Paris, France","The Black Plague"]
     
          let Answer4 = ["Woodrow Wilson","Alabama","Thailand","Yugoslavia","1961","1530","After bomb threats from Austria deserted towards Siberia.","The Titanic sank","The leader of China in the 6th century","10 years","116 years","1969","Sweden","The Battle of Waterloo","Sun Yat-sen","Leon Trotsky","1864","David Scott","Eli Whitney","1820","Homer","The Bastille","Cuban Missile Crisis","The 16th Century","World War II","December 7, 1948","René Ramos Latour","1","1941 to 1945","Chaldea","4 terms","Benjamin Franklin","Italy","Second Anglo-Boer War","Tuvalu","Achaemenid Empire","4,414","2 days","Socrates","Afghanistan","Sweden","A Venezulean political activist","It came from Fleas and Rodents from Central Asia","1856","William Mckinley","He was one of the writers for the Declaration of Independence","Mustafa Kemal Atatürk","James Madison","Start of persecution in Austria of Germans","Martin Luther King Jr.","Texas","Jane Seymore","Mexico","Boris Yeltsin","Tang Dynasty","Herbert Hover","1900","American Revolutionary War","War of 1788","Atlantic Ocean","Thucydides","Maximilien Robespierre","Baghdad","July 1, 1899","England","Word War I","John J. Williams","Outlast the imperial government","Germany and Great Britain","1854","Angela Merkel","1974","John F. Kennedy","Aztec Civilization","1933","To make an economic deal","Andrew Jackson","December 16, 1773","Germany","Research by the U.S. to make the Atomic Bomb during World War II","1756","Otto Von Bismarck"," Christopher Columbus","Ghana","Battle of Hastings","William Mckinley","Russia","Xia Dynasty","United States of America","6 Days","1948","Thabo Mbeki","Increasing the minimum wage in India","July 6, 1963","Battle of Agincourt","Andrew Johnson","Battle of Tannenberg","5","Normandy, France","Cholera"]
     
         let CorrectAnswer = [1,4,3,2,4,1,2,4,3,3,4,2,1,4,2,3,2,1,4,1,3,4,1,2,4,2,1,3,4,1,1,2,3,4,1,3,4,2,1,4,2,3,4,1,2,3,4,3,2,4,3,1,2,4,3,1,3,1,2,3,2,4,2,1,3,4,2,1,2,1,4,1,2,3,4,3,2,3,1,4,2,4,3,2,1,3,1,4,1,2,4,2,3,1,3,4,3,1,2,4]
     
     
     
     
         let questionTF = ["Gunpowder was invented in China.","The Nazis occupied Greece during World War II.","The Berlin Wall came down in November of 1989.","The Vietnam War ended in the 1960s.","Mexico achieved independence before the USA.","Alexander the Great was appointed a Pharaoh of Egypt.","The Magna Carta was signed in England","The Battle of Hastings was fought on October 14, 1066.","The Battle of Agincourt took place during the 7 years war.","Mahatma Gandhi was killed in 1946.","Rosa Parks started the Underground Railroad.","The Salem Witch Trials resulted in 50 deaths.","More than 100 countries were involved in World War I.","Ronald Regan & Mikhail Gorbachev were instrumental in bringing down the Berlin Wall.","Wojciech Jaruzelski was responsible for bringing an end to communism in Poland.","The Great Wall of China was built by the order of Emperor Gaxou of Han.","The Cold War was a period of geopolitical tension between the U.S. & China.","The United States did not enter World War II until Pearl Harbor was attacked.","The Battle of Antietam is known as the bloodiest single day battle in history.","The Open Door policy developed by the U.S. to allow equal trading in China.","The Treaty of Taif was signed after the Gulf War.","The Treaty of Ghent ended the Cold War.","The surrender of Japan after World War II led to the division of Korea.","In 1950, America got involved in the Korean War.","The Civil War is known as the bloodiest war in World history.","The capital of the Aztec empire was Tikal.","The first electrically lighted city in the world was Wabash, Indiana.","American Independence day is on July 4th.","The first war recorded in history took place in Mesopotamia.","The Russian Ruble is the world's oldest form of currency that is still in use.","Before 1752, February was the first month of the year.","Socrates was the founder of the Platonist School of thought.","The Wampanoag tribe befriended the Pilgrims after they landed at Plymouth Rock.","Treaties between the Native Americans and the U.S. Government were enforced.","The Aztecs believed that human sacrifice nourished their gods.","The ancient city of Rome was built on 7 hills.","The Afgan War is the longest war in  U.S. history.","Italy was not a member of the Allied powers during World War I.","The Han dynasty was the first dynasty of imperial China.","The U.S. acquired Alaska from Britain.","The Aswan High Dam was built in 1970 to prevent flooding of the Nile River.","The Rosetta Stone helped experts learn to read Egyptian Hieroglyphs.","Catholicism was brought to Ireland by St.Patrick in the year 1200.","The Great Famine was a period of mass starvation in England.","Hati overthrew its colonizer France in 1785.","From 711 to 1236, Christian, Muslims, and Jewish people coexisted in Cordoba.","Mexico defeated Spain in 1810  gaining independence.","The United Nations was established in 1945.","Augusto Pinochet overthrew leader Salvador Allende of Chile.","Julius Caesar to the rise of the Mayan civilization.","The 1707 Act of Union led to the creation of the United Kingdom of Great Britain.","The Reign of Terror was during the American Revolution.","The Protestant Reformation was started by John Calvin","Che Guevara was a notable figure in the Cuban Revolution.","Vikings were the first people to settle in Greenland.","Vladimir Lenin led the USSR from 1917 to 1922.","The Stonewall Riots were a series of violent protests by British Colonists.","The 18th Amendment granted women the right to vote in the United States.","The Djoser Step Pyramid is the oldest pyramid in the world.","The Declaration of Independence was signed in 1776.","The period of unrecorded history is known as the Pre Historic Age.","Socrates was the most famous ruler of ancient Athens.","Mecca is considered the Holy City of Judaism.","Egypt, Jordan, and Syria have all invaded Israel.","The Lusitania was sunk by a German submarine.","Friedrich Reich was Karl Marx’s associate and fellow political theoractian.","King James signed the Magna Carta.","The Magna Carta was created to protect the rights of citizens.","Four  U.S. presidents have won the election without winning the popular vote.","The Opium war was between the United States & China.","The partition of British India occurred on August 14 - 15 1947.","Nelson Mandela was an anti Apartheid activisit for South Africa.","The Treaty of Versailles angered France and led to World War II.","There were 10 amendments in the original Bill of Rights.","Apartheid was officially aboished in 1995.","The Spanish Civil War was from 1936 to 1939.","Joseph Stalin led the USSR during World War II."," William J. Brennan was the first African American Supreme Court justice.","The Emancipation Proclamation became law in 1866.","Rome was founded in 753 BC.","John F. Kennedy was assassinated in Manhattan, New York.","Simon Bolivar was responsible for liberating much of South Africa.","England sent convicts to Australia between 1788 & 1868.","Margaret Thatcher was the first female Prime Minister of Israel.","Mein Kamph was written by Karl Marx while he was in prison.","The Titanic set sail from Southampton, England.","On June 6, 1939 the Allies invaded Europe at Normandy.","Franklin Roosevelt was the first U.S. president to appear on TV.","Both Hitler and Napoleon failed when deciding to invade Russia in the winter.","In England slavery was abolished in 1833.","Jeremy Clarkson kept a diary of the Great Fire of London.","The Battle of Hastings was fought in France.","Anne Frank wrote a diary while hiding out during the Holocaust.","Emperor Nero built a wall across the North Side of England.","Adolf Hitler was the leader of the Nazi party.","The Statue of Liberty was a gift from France.","The War of Spanish Succession was from 1701 to 1714.","The Kosovo War was a 10 week war between Argentina & the United Kingdom.","A Spitfire is a fighter plane used during World War I.","Zapotec Civilization is the oldest civilization in the Americas."]
     
     
     
          let explanationTF = ["","","The Berlin Wall came down in November of 1991.","The Vietnam War ended in the 1970s.","Mexico achieved independence after the USA.","","","","The Battle of Agincourt took place during the 100 years war.","Mahatma Gandhi was killed in 1947.","Harriet Tubman started the Underground Railroad.","The Salem Witch Trials resulted in 25 deaths.","","","Lech Wałęsa was responsible for bringing an end to communism in Poland.","The Great Wall of China was built by the order of Emperor Qin Shi Huang.","The Cold War was a period of geopolitical tension between the U.S. & Soviet Union.","","","","The Treaty of Taif was signed after Saudi Arabia's victory over Yemen.","The Treaty of Ghent ended the War of 1812.","","","World War II is known as the bloodiest war in World history.","The capital of the Aztec empire was Tenochtitlan.","","","","The British Pound is the world's oldest form of currency that is still in use.","Before 1752, March was the first month of the year.","Plato was the founder of the Platonist School of thought.","","Treaties between the Native Americans and the U.S. Government were not enforced.","","","","","The Qin dynasty was the first dynasty of imperial China.","The U.S. acquired Alaska from Russia.","","","","The Great Famine was a period of mass starvation in Ireland.","Hati overthrew its colonizer France in 1804.","","","",""," Julius Caesar to the rise of the Roman Empire.","","The Reign of Terror was during the French Revolution.","The Protestant Reformation was started by Martin Luther.","","","","The Stonewall Riots were a series of violent protests by Gay people.","The 19th Amendment granted women the right to vote in the United States.","","","","Pericles was the most famous ruler of ancient Athens.","Jerusalem is considered the Holy City of Judaism.","","","Fedrick Engles was Karl Marx’s associate and fellow political theoractian.","King John signed the Magna Carta.","","Five  U.S.  presidents have won the election without winning the popular vote.","The Opium war was between Britain & China.","","","The Treaty of Versailles angered Germany & led to World War II.","","Apartheid was officially aboished in 1994.","","","Thurgood Marshall was the first African American Supreme Court justice.","The Emancipation Proclamation became law in 1863.","","John F. Kennedy was assassinated in Dallas, Texas.","","","Golda Meir was the first female Prime Minister of Israel.","Mein Kamph was written by Hitler while he was in prison.","","On June 6, 1944 the Allies invaded Europe at Normandy.","","","","Samual Pepyes kept a diary of the Great Fire of London.","The Battle of Hastings was fought in England.","","Emperor Hadrian built a wall across the North Side of England.","","","","The Falkland War was a 10 week war between Argentina & the United Kingdom.","","The Norte Chico Civilization is the oldest civilization in the Americas."]
     
     
         let correctAnswerTF = [1,1,2,2,2,1,1,1,2,2,2,2,1,1,2,2,2,1,1,1,2,2,1,1,2,2,1,1,1,2,2,2,1,2,1,1,1,1,2,2,1,1,2,2,2,1,1,1,1,2,1,2,2,1,1,1,2,2,1,1,1,2,2,1,1,2,2,1,2,2,1,1,2,1,2,1,1,2,2,1,2,1,1,2,2,1,2,1,1,1,2,2,1,2,1,1,1,2,1,2]

    var numberOfNames = 0
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
         //downloadTrueAndFalse()
         //downloadMultipleChoiceQuestions()
         //ResetPointsForPlayers()
         uploadMultipleChoice()
         trueAndFalseUpload()

        
    }
    //reset points of each player in the users collection (use at the beginning of each month)
    
    func ResetPointsForPlayers(){
        
        let db = Firestore.firestore()
                       db.collection("users").getDocuments()
                        {(querySnapshot,err) in
                            self.numberOfNames = querySnapshot?.count as! Int
                               if let err = err{
                                
                                   print("The error was \(err)")
                               }
                           else
                               {
                                   //var count = 0
                                   for document in querySnapshot!.documents {
                               
                                     
                                    self.counter+=1
                                   print("ran")
                                    self.userPoints.append(document["points"] as! Int)
                                    self.userUID.append(document.documentID)
                                    print(document.documentID)
                                    print(self.numberOfNames)
                                    print(self.counter)
                                    if (self.numberOfNames <= self.counter){
                                        self.usersUpdatePoints()
                                        //                                  print(self.userPoints as Any)
                                        }
        //
                                       }
                                       }
                            
                              
                           
                
        }
                          
    
    }
            func usersUpdatePoints(){
                var count = 0

                for x in userUID{
                           print("for loop")
                    Firestore.firestore().collection("users").document(userUID[count]).updateData(["points":0])
                           {(error) in
                            if error != nil {
                                print("Couldn't be saved on the database,Try Again")
                         }
                         }
                          count+=1
                       }
    }
    


        //DOWNLOAD QUESTIONS STEPPPP 1
        
 func downloadMultipleChoiceQuestions(){
        var x = 0;
       let db = Firestore.firestore()
       db.collection("quizs").getDocuments()
           {(querySnapshot,err) in
               if let err = err{
                   print("The error was \(err)")
               }
           else
               {
                   var count = 0
                   for document in querySnapshot!.documents {
               
                     

                   print("ran")
                    self.question1Q.append(document["Question"] as! String)
                    self.answer1Q.append(document["Answer1"] as! String)
                    self.answer2Q.append(document["Answer2"] as! String)
                    self.answer3Q.append(document["Answer3"] as! String)
                    self.answer4Q.append(document["Answer4"] as! String)
                    self.correctAnswerQ.append(document["correctAnswer"] as! Int)
                        x+=1
                        
                        
                        
                       }
                       }
              
           }
    self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.decrementProgress), userInfo: nil, repeats: false)
          }
@objc func decrementProgress() {
    let totalDuration = -3
    if totalDuration <= 0 {
     timer.invalidate()
        print("Question:")
     for x in 0...99{
    print("\"\(question1Q[x])\",", terminator:"")
    
     }
        print("")
        print("Answer1:")
     for x in 0...99{
       print("\"\(answer1Q[x])\",", terminator:"")
     }
        print("")
        print("Answer2:")
     for x in 0...99{
       print("\"\(answer2Q[x])\",", terminator:"")
     }
        print("")
        print("Answer3:")
     for x in 0...99{
       print("\"\(answer3Q[x])\",", terminator:"")
     }
        print("")
        print("Answer4:")
     for x in 0...99{
       print("\"\(answer4Q[x])\",", terminator:"")
     }
        print("correctAnswer:")
        print("")
     for x in 0...99{
       print("\(correctAnswerQ[x]),", terminator:"")
     }
    }
}
    
        
    func downloadTrueAndFalse(){
        var x = 0;
        let db = Firestore.firestore()
        db.collection("trueAndFalse").getDocuments()
            {(querySnapshot,err) in
                if let err = err{
                    print("The error was \(err)")
                }
            else
                {
                    //var count = 0
                    for document in querySnapshot!.documents {
                
                      

                    print("ran")
                     self.questionTFD.append(document["question"] as! String)
                     self.explanationTFD.append(document["explanation"] as! String)
                     self.correctAnswerTFD.append(document["correctAnswer"] as! Int)
                    
                         x+=1
                         
                         
                         
                        }
                        }
               
            }
              self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.decrementProgressTF), userInfo: nil, repeats: false)
         }
@objc func decrementProgressTF() {
           let totalDuration = -3
           if totalDuration <= 0 {
            timer.invalidate()
               print("Question:")
            for x in 0...99{
           print("\"\(questionTFD[x])\",", terminator:"")
           
            }
               print("")
               print("explanation:")
            for x in 0...99{
              print("\"\(explanationTFD[x])\",", terminator:"")
            }
               print("")
               print("correctAnswer:")
            for x in 0...99{
              print("\(correctAnswerTFD[x]),", terminator:"")
            }
           }
        
    }
        
    
        
       
        
        
    //UPLOAD MULTIPLE CHOICE///////////////////////////// STEPPPPPPPP 5
    func uploadMultipleChoice(){
        for x in 0...99{
            print("for loop")
            Firestore.firestore().collection("quizs").document(String(x)).setData(["Question":question[x], "Answer1":Answer1[x],"Answer2":Answer2[x],"Answer3":Answer3[x],"Answer4":Answer4[x],"correctAnswer":CorrectAnswer[x]])
         {(error) in
             if error != nil {
                 print("Couldn't be saved on the database,Try Again")
          }
          }
             
        }
    }
    
       
        // Do any additional setup after loading the view.
    
    
    

    func trueAndFalseUpload(){
    for x in 0...99{
            print("for loop")
            Firestore.firestore().collection("trueAndFalse").document(String(x)).setData(["question":questionTF[x], "explanation":explanationTF[x],"correctAnswer":correctAnswerTF[x]])
                       {(error) in
                           if error != nil {
                               print("Couldn't be saved on the database,Try Again")
                        }
                        }
                           
                      }
    }

    
override func viewDidAppear(_ animated: Bool) {

}
    


 }

