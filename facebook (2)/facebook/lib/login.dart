import 'package:flutter/material.dart';
import 'signup.dart';
import 'home.dart';

class loginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 219, 219),
      body:Center( 
        child:
          Column(
            children: [
              Text('facebook',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                  )
                ),

              SizedBox(height: 20,),
              Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: 
                  Column(
                    children: [
                      SizedBox(height: 10,),

                      Text('Login to facebook', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                          )
                        ),

                      SizedBox(height: 20,),
                      SizedBox(  
                        width : 300,
                        child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade400)
                          )
                        ),
                      ),

                      ),
                      SizedBox(height: 20,),
                        SizedBox(
                          width : 300,
                          child:
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.grey.shade400)
                              )
      
                            ),
                          
                          
                          ),
                        ),
                      SizedBox(height: 20,),

                      SizedBox(
                        width : double.infinity,
                        child:
                        TextButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => homePage()),
                              );
                              },
                          style: TextButton.styleFrom(backgroundColor: Colors.blue),
                          child: Text('Log In', 
                            style: TextStyle(
                              color: Colors.white
                              )
                        ),
                      ),
                      ),
                        
                      SizedBox(height: 4,),
                      TextButton(
                        onPressed: () {},
                        child: Text('Forgotten Password?', 
                          style: TextStyle(
                            color: Colors.blue
                            )
                          )
                        ),

                      SizedBox(height: 4,),

                      Text('------------------OR------------------',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                          )
                        ), 

                      SizedBox(height: 4,),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => signupPage()),
                          );
                        },
                        child: Text('Create New Account', 
                          style: TextStyle(
                            color: Colors.blue,
                            )
                          )
                      ),
                    ],
                    )

                ),
            ],

      ),
    )
    );
  }
}
