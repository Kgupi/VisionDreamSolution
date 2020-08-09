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

using System.Collections.Generic;
using VisionDream.Data.Models.OLenakeModels;

namespace VisionDream.Data.ExtendedModels.OLenakeExtendedModels
{
    public class OnkgopotseExtended : IEntityInt
    {
        public int Id { get; set; }
        public string ExtPersonTypeCode { get; set; }
        public string ExtFirstName { get; set; }
        public string ExtSurname { get; set; }
        public char ExtGender { get; set; }
        public Email ExtEmailAddress { get; set; }
        public Address ExtAddress { get; set; }

        public IEnumerable<PersonType> ExtPersonTypeCodes { get; set; }

        public OnkgopotseExtended()
        {

        }

        /// <see cref="OnkgopotseExtended"/> constructor enabled/disabled to configure lazy-loading.
        public OnkgopotseExtended(Onkgopotse onkgopotseEntity)
        {
            Id = onkgopotseEntity.Id;
            ExtPersonTypeCode = onkgopotseEntity.PersonTypeCode;
            ExtFirstName = onkgopotseEntity.FirstName;
            ExtSurname = onkgopotseEntity.Surname;
            ExtGender = onkgopotseEntity.Gender;
            ExtEmailAddress = onkgopotseEntity.EmailAddress;
            ExtAddress = onkgopotseEntity.Address;
        }
    }
}
