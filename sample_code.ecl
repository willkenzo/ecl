IMPORT STD;

// Defining layouts
layoutPeople := RECORD
    UNSIGNED PersonID;
    STRING   FirstName;
    STRING   LastName;
END;

layoutAddress := RECORD
    UNSIGNED PersonID;
    STRING   State;
    STRING   City;
END;

// Datasets refer to Physical or In-Memory data
dPeople := DATASET(// Data
                   [{1, 'Fred', 'Smith'},
                    {2, 'Joe', 'Blow'},
                    {3, 'Jane', 'Smith'}],
                   // Layout
                   layoutPeople);

dAddress := DATASET([// Data
                     {1, 'SP', 'Sao Paulo'},
                     {2, 'RJ', 'Rio de Janeiro'},
                     {3, 'MG', 'Belo Horizonte'}],
                     // Layout
                    layoutAddress);

// Uppercase in all STRING columns from dPeople and dAddress
dPeople1 := TABLE(dPeople,
                  {UNSIGNED PersonID  := dPeople.PersonID;
                   STRING   FirstName := STD.Str.ToUpperCase(dPeople.FirstName);
                   STRING   LastName  := STD.Str.ToUpperCase(dPeople.LastName)});  

dAddress1 := TABLE(dAddress,
                   {UNSIGNED PersonID := dAddress.PersonID;
                    STRING   State    := STD.Str.ToUpperCase(dAddress.State);
                    STRING   City     := STD.Str.ToUpperCase(dAddress.City)});
// LEFT JOIN
layoutJoin := RECORD
    UNSIGNED PersonID;
    STRING   FirstName;
    STRING   LastName;
    STRING   State;
    STRING   City;
END;

layoutJoin functionJoin(layoutPeople L, layoutAddress R) := TRANSFORM
    SELF.PersonID  := L.PersonID;
    SELF.FirstName := L.FirstName;
    SELF.LastName  := L.LastName;
    SELF.State     := R.State;
    SELF.City      := R.City;
END;

dPeopleAddress :=  JOIN(dPeople1,
                        dAddress1, 
                        LEFT.PersonID = RIGHT.PersonID,
                        functionJoin(LEFT, RIGHT),
                        LEFT OUTER,
                        LOCAL);

//  Outputs
OUTPUT(dPeople1);
OUTPUT(dAddress1);
OUTPUT(dPeopleAddress);