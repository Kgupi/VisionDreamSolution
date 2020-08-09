/* ****************************************************************************
 * Copyright 2020 VisionDream ICT Solutions
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy 
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 * ***************************************************************************/

using System;
using System.Collections.Generic;
using VisionDream.Data.Models.OLenakeModels;

namespace VisionDream.Data.ExtendedModels.OLenakeExtendedModels
{
    public class OnkgopotseExtendedModel : IEntityInt
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string Surname { get; set; }
        public DateTime BirthDate { get; set; }
        //public string PhoneNumber { get; set; }
        //public DateTime CreatedDate { get; set; }
        public Email EmailAddress { get; set; }
        public Address Address { get; set; }

        //public PersonType PersonTypes { get; set; }

        public OnkgopotseExtendedModel(Onkgopotse onkgopotse)
        {
            Id = onkgopotse.Id;
        }
    }
}
