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

namespace VisionDream.Data.Extensions
{
    /// <summary>
    /// The static <see cref="IEntityExtensions"/>, extension class helps to check entities for two conditions: 
    ///     1. Check if the whole entity object is null <see cref="IsObjectNull"/> and 
    ///        assign it the value 'null', if the condition is true.
    ///     2. Check if the entity.ID property is empty <see cref="IsObjectEmpty"/> and 
    ///        assign it the value 'Empty', if the condition is true.
    /// </summary>
    public static class IEntityExtensions
    {
        public static bool IsObjectNull(this IEntity entity)
        {
            return entity == null;
        }

        public static bool IsObjectEmpty(this IEntity entity)
        {
            return entity.Id.Equals(Guid.Empty);
        }
    }
}
