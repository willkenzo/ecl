IMPORT STD;

// Defining layouts
lPeople := RECORD
    UNSIGNED PersonID;
    STRING   FirstName;
    STRING   LastName;
END;

lAddress := RECORD
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
                   lPeople);

dAddress := DATASET([// Data
                     {1, 'SP', 'Sao Paulo'},
                     {2, 'RJ', 'Rio de Janeiro'},
                     {3, 'MG', 'Belo Horizonte'}],
                     // Layout
                    lAddress);

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
lPeopleAddress := RECORD
    UNSIGNED PersonID;
    STRING   FirstName;
    STRING   LastName;
    STRING   State;
    STRING   City;
END;

dPeopleAddress :=  JOIN(dPeople1,
                        dAddress1,
                        LEFT.PersonID = RIGHT.PersonID,
                        TRANSFORM(lPeopleAddress, 
                                  SELF.PersonID  := LEFT.PersonID;
                                  SELF.FirstName := LEFT.FirstName;
                                  SELF.LastName  := LEFT.LastName;
                                  SELF.State     := RIGHT.State;
                                  SELF.City      := RIGHT.City),
                        LEFT OUTER,
                        LOCAL);

//  Outputs
OUTPUT(dPeople1);
OUTPUT(dAddress1);
OUTPUT(dPeopleAddress);