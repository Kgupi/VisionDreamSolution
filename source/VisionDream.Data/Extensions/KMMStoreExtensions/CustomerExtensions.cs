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

using VisionDream.Data.Models.KMMStoreModels;

namespace VisionDream.Data.Extensions.KMMStoreExtensions
{
    /// <summary>
    /// The static <see cref="CustomerExtensions"/> class helps to map <see cref="Map"/> 
    /// the same two <see cref="Customer"/> object entities (<see cref="dbCustomer"/> 
    /// and <see cref="customer"/>) to each other, for further processing.
    /// </summary>
    public static class CustomerExtensions
    {
        public static void Map(this Customer dbCustomer, Customer customer)
        {
            dbCustomer.Id = customer.Id;
            //dbCustomer.PersonType = customer.PersonType;
            dbCustomer.FirstName = customer.FirstName;
            dbCustomer.Surname = customer.Surname;
            //dbCustomer.PhoneNumber = customer.PhoneNumber;
            dbCustomer.EmailAddress = customer.EmailAddress;
            dbCustomer.LocationAddress = customer.LocationAddress;
        }
    }
}
