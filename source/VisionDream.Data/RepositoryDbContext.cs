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
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using VisionDream.Data.Models.KMMStoreModels;
using VisionDream.Data.Models.LibraryManagerModels;
using VisionDream.Data.Models.OLenakeModels;

namespace VisionDream.Data
{
    /// <summary>
    /// The <see cref="RepositoryDbContext"/> class is the main generic <see cref="DbContext"/> 
    /// (GenericDbContext) model that facilitates the <see cref="Onkgopotse"/> entity's 
    /// data and it's related data manipulations. It also facilitates the 
    /// <see cref="Book"/> and <see cref="Product"/> entities with their data for manipulations.
    /// </summary>
    public class RepositoryDbContext : DbContext
    {
        /// <summary>
        /// Inject the loggerUtility and repositoryContext parameter services inside the constructor.
        /// </summary>
        public RepositoryDbContext(DbContextOptions<RepositoryDbContext> options) : base(options)
        {
        }

        //public DbSet<Onkgopotse> Onkgopotse { get; set; }
        public DbSet<Book> Book { get; set; }
        //public DbSet<Product> Product { get; set; }
        //public virtual DbSet<Employee> Employees { get; set; }
        //public virtual DbSet<Province> Provinces { get; set; }
        //public virtual DbSet<Owner> Owners { get; set; }
        //public virtual DbSet<Account> Accounts { get; set; }
    }
}
